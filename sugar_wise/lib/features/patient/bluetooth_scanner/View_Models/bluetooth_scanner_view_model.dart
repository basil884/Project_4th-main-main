import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';
import 'package:location/location.dart' as loc; // 🔥 أضف هذا في الأعلى

// 📡 الموديل الخاص بالجهاز
class BleDeviceModel {
  final BluetoothDevice device;
  final String name;
  int rssi;
  bool isConnected;
  bool isConnecting;

  BleDeviceModel({
    required this.device,
    required this.name,
    required this.rssi,
    this.isConnected = false,
    this.isConnecting = false,
  });

  IconData get signalIcon {
    if (rssi > -60) return Icons.signal_cellular_alt_rounded;
    if (rssi > -80) return Icons.signal_cellular_alt_2_bar_rounded;
    return Icons.signal_cellular_alt_1_bar_rounded;
  }

  Color get signalColor {
    if (rssi > -60) return Colors.green;
    if (rssi > -80) return Colors.orange;
    return Colors.redAccent;
  }

  String get signalText {
    if (rssi > -60) return "Strong Signal";
    if (rssi > -80) return "Medium Signal";
    return "Weak Signal";
  }
}

class BluetoothScannerViewModel extends ChangeNotifier {
  bool isScanning = false;
  int currentHeartRate = 0; // 🔥 متغير لتخزين نبض القلب الحي
  // 🔥 المتغيرات الجديدة
  int currentSystolic = 0; // الضغط الانقباضي (الرقم الكبير)
  int currentDiastolic = 0; // الضغط الانبساطي (الرقم الصغير)
  double sleepHours = 0.0; // ساعات النوم
  int currentGlucose = 0; // سكر الدم (سنجهزه للأجهزة الطبية أو الإدخال اليدوي)

  List<BleDeviceModel> devices = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  Future<void> startScanning(BuildContext context) async {
    // 💡 حماية إضافية: لا تقم ببدء بحث جديد إذا كان الرادار يعمل بالفعل
    if (FlutterBluePlus.isScanningNow) {
      debugPrint("⚠️ Scanner is already running.");
      return;
    }
    loc.Location location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      debugPrint("⚠️ GPS is off. Attempting to turn it on automatically...");
      serviceEnabled = await location
          .requestService(); // يظهر نافذة تفعيل الـ GPS

      if (!serviceEnabled) {
        // إذا رفض المستخدم تشغيل الموقع
        if (!context.mounted) return;
        _showToast(
          context,
          "Location (GPS) must be turned on to find the sensor!",
          isError: true,
        );
        return;
      }
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (!context.mounted) return;

    if (!statuses.values.every((status) => status.isGranted)) {
      _showToast(
        context,
        "Bluetooth and Location permissions are required!",
        isError: true,
      );
      return;
    }

    try {
      var state = await FlutterBluePlus.adapterState.first;
      // if (!context.mounted) return;

      if (state != BluetoothAdapterState.on) {
        debugPrint(
          "⚠️ Bluetooth is off. Attempting to turn it on automatically...",
        );

        try {
          // 🚀 هذا السطر يظهر نافذة التفعيل التلقائي للبلوتوث (على أندرويد)
          await FlutterBluePlus.turnOn();

          // ننتظر ثانية واحدة لضمان تشغيل الهاردوير الخاص بالبلوتوث قبل البحث
          await Future.delayed(const Duration(seconds: 1));
        } catch (e) {
          // إذا رفض المستخدم أو كان النظام (iOS) يمنع التفعيل التلقائي
          if (!context.mounted) return;
          _showToast(
            context,
            "Please turn on Bluetooth manually from settings!",
            isError: true,
          );
          return;
        }
      }
    } catch (e) {
      debugPrint("Adapter State Check Error: $e");
    }

    isScanning = true;
    devices.clear();
    notifyListeners();

    try {
      // بدء البحث
      debugPrint("🚀 Starting Bluetooth Scan...");
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      // 🔥 طباعة الخطأ الدقيق القادم من أندرويد لمعرفة السبب الحقيقي
      debugPrint("❌ Start Scan Error EXACT REASON: $e");

      if (!context.mounted) return;

      // عرض الخطأ للمستخدم بدلاً من الرسالة المبهمة
      _showToast(
        context,
        "Scan Error: ${e.toString().split(':').last}",
        isError: true,
      );
      isScanning = false;
      notifyListeners();
      return;
    }

    // الاستماع للأجهزة
    _scanSubscription?.cancel();
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        String deviceName = r.advertisementData.advName;
        if (deviceName.isEmpty) {
          deviceName = r
              .device
              .platformName; // 2. إذا كان فارغاً، نقرأ الاسم المخزن في الموبايل
        }
        // عرض الأجهزة المخفية بالماك أدرس للتأكد من عمل الرادار
        if (deviceName.isEmpty) {
          // 3. إذا فشل الاثنان، نعرض الماك أدرس لكي نعرف أنه جهاز موجود
          deviceName = "Unknown (${r.device.remoteId.str.substring(0, 8)})";
        }

        int safeRssi = -100;
        try {
          safeRssi = r.rssi;
        } catch (_) {}
        int existingIndex = devices.indexWhere(
          (d) => d.device.remoteId == r.device.remoteId,
        );
        if (existingIndex >= 0) {
          devices[existingIndex].rssi = safeRssi;
          // تحديث الاسم إذا تم اكتشافه لاحقاً
          if (devices[existingIndex].name.startsWith("Unknown") &&
              !deviceName.startsWith("Unknown")) {
            devices[existingIndex] = BleDeviceModel(
              device: r.device,
              name: deviceName,
              rssi: safeRssi,
            );
          }
        } else {
          // 🔥 فلتر إضافي لتنظيف الشاشة: تجاهل الأجهزة المجهولة تماماً إذا أردت (اختياري)
          if (deviceName.startsWith("Unknown")) continue;

          devices.add(
            BleDeviceModel(device: r.device, name: deviceName, rssi: safeRssi),
          );
        }
      }
      notifyListeners();
    });

    _isScanningSubscription?.cancel();
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((scanning) {
      if (isScanning != scanning) {
        isScanning = scanning;
        notifyListeners();
      }
    });
  } // 🔗 الاتصال الحقيقي بالجهاز

  // 🔗 الاتصال الحقيقي بالجهاز
  // 🔗 الاتصال الحقيقي والجذري بالجهاز
  // 🔗 الاتصال الحقيقي والجذري بالجهاز وقراءة البيانات
  Future<void> connectToDevice(
    BuildContext context,
    BluetoothDevice device,
  ) async {
    var deviceIndex = devices.indexWhere(
      (d) => d.device.remoteId == device.remoteId,
    );
    if (deviceIndex == -1) return;

    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    devices[deviceIndex].isConnecting = true;
    notifyListeners();

    try {
      debugPrint("⏳ Attempting to connect to ${device.platformName}...");
      await device.disconnect();

      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
        mtu: null,
        license: License.free,
      );
      device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.disconnected) {
          debugPrint("⚠️ Device disconnected!");
          devices[deviceIndex].isConnected = false;
          notifyListeners();
        }
      });

      // =========================================================
      // 🔥 مرحلة استكشاف البيانات (Services & Characteristics)
      // =========================================================
      List<BluetoothService> services = await device.discoverServices();
      debugPrint("✅ Discovered ${services.length} services.");

      for (BluetoothService service in services) {
        debugPrint("📡 Service Found UUID: ${service.uuid.toString()}");

        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          debugPrint(
            "  ⚡ Characteristic UUID: ${characteristic.uuid.toString()}",
          );
          debugPrint(
            "     - Properties: Read(${characteristic.properties.read}), Notify(${characteristic.properties.notify}), Write(${characteristic.properties.write})",
          );

          // 💡 هنا نحاول الاستماع للبيانات (Subscribe/Notify)
          // المعيار العالمي لنبض القلب هو Service تبدأ بـ 180d والـ Characteristic تبدأ بـ 2a37
          if (characteristic.properties.notify ||
              characteristic.properties.indicate) {
            try {
              // نفعل خاصية الاستماع المستمر لهذه القناة
              await characteristic.setNotifyValue(true);

              // نستقبل البيانات الحية فوراً من الساعة
              characteristic.onValueReceived.listen((value) {
                if (value.isNotEmpty) {
                  String charUuid = characteristic.uuid
                      .toString()
                      .toLowerCase();

                  // إذا كانت البيانات قادمة من قناة fea1 أو القناة القياسية لنبض القلب 2a37
                  if (charUuid.contains("fea1") || charUuid.contains("2a37")) {
                    if (value.length >= 2) {
                      int extractedHr = value[1];
                      if (extractedHr > 40 && extractedHr < 220) {
                        currentHeartRate = extractedHr;
                        notifyListeners();
                      }
                    }
                  }
                  if (charUuid.contains("ae02") || charUuid.contains("0003")) {
                    // نحن لا نعرف ترتيب البايتات، لذلك سنطبعها لنحللها لاحقاً!
                    debugPrint("🕵️‍♂️ MYSTERY DATA from [$charUuid]: $value");

                    // افتراض هندسي: غالباً الضغط يأتي في بايتين متتاليين (مثلاً 120 و 80)
                    // سنقوم بتجربة التقاطها إذا كان طول المصفوفة كافياً
                    if (value.length >= 4) {
                      // مجرد تخمين مبدئي لمكان الضغط
                      // currentSystolic = value[2];
                      // currentDiastolic = value[3];
                      // notifyListeners();
                    }
                  }
                }
                // القيمة تأتي كـ List of Bytes (أرقام مثل [20, 75, 100]) سنقوم بفك تشفيرها لاحقاً
              });
            } catch (e) {
              debugPrint(
                "❌ Failed to set notify for ${characteristic.uuid}: $e",
              );
            }
          }

          // إذا كانت القناة تدعم القراءة المباشرة لمرة واحدة
          if (characteristic.properties.read) {
            try {
              var value = await characteristic.read();
              debugPrint("📖 READ DATA from [${characteristic.uuid}]: $value");
            } catch (e) {
              debugPrint("❌ Failed to read ${characteristic.uuid}: $e");
            }
          }
        }
      }
      // =========================================================

      devices[deviceIndex].isConnecting = false;
      devices[deviceIndex].isConnected = true;
      notifyListeners();

      if (!context.mounted) return;
      _showToast(
        context,
        "Connected to ${device.platformName}!",
        isError: false,
      );

      // 🛑 قمت بتعطيل الانتقال للشاشة التالية مؤقتاً لكي ترى البيانات في ה-Terminal

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PatientMainLayout()),
        );
      });
    } catch (e) {
      debugPrint("❌ Real Connection Error: $e");
      await device.disconnect();
      devices[deviceIndex].isConnecting = false;
      devices[deviceIndex].isConnected = false;

      if (!context.mounted) return;
      _showToast(
        context,
        "Failed to connect: ${e.toString().split(':').last}",
        isError: true,
      );
      notifyListeners();
    }
  }

  // دالة مساعدة لظهور الرسائل
  void _showToast(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 🔥 دالة رفع البيانات الحية إلى سيرفر Node.js
  Future<void> syncDataToServer(BuildContext context) async {
    // لا نرسل بيانات إذا لم يكن هناك قياس فعلي
    if (currentHeartRate == 0 && currentSystolic == 0) {
      _showToast(context, "No active data to sync!", isError: true);
      return;
    }

    try {
      // 1. تجهيز شكل البيانات (JSON Payload)
      final payload = {
        "patient_id":
            "USER_ID_HERE", // هنا تضع الـ ID الخاص بالمريض المسجل للدخول
        "recorded_at": DateTime.now().toUtc().toIso8601String(),
        "device_used": "Smart Bluetooth Sensor",
        "metrics": {
          "heart_rate": currentHeartRate != 0 ? currentHeartRate : null,
          "blood_glucose": null, // مؤقتاً
          "systolic_bp": currentSystolic != 0 ? currentSystolic : null,
          "diastolic_bp": currentDiastolic != 0 ? currentDiastolic : null,
          "sleep_hours": sleepHours != 0.0 ? sleepHours : null,
        },
      };

      // 2. إرسالها للـ API عبر الـ Dio
      // افتراض أن مسار الـ API هو /health/sync
      // final response = await ApiClient.post('/health/sync', data: payload);
      final dio = Dio();
      final response = await dio.post(
        'https://your-api-url.com/api/health/sync',
        data: payload,
      );
      if (response.statusCode == 201) {
        if (context.mounted) {
          _showToast(context, "Data synced securely!", isError: false);
        }
      }
    } catch (e) {
      debugPrint("Sync Error: $e");
      if (context.mounted) {
        _showToast(context, "Failed to sync data", isError: true);
      }
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _isScanningSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
