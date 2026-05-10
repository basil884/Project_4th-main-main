import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:sugar_wise/core/app_keys.dart';

const int kZegoAppID = 720576293;
const String kZegoAppSign =
    "cc885dc9d4d26b43c33cbac39ddcd0aa59dee86733179152a9e297b6ef64ba03";

class ZegoCallService {
  static final ZegoCallService _instance = ZegoCallService._internal();
  factory ZegoCallService() => _instance;
  ZegoCallService._internal();

  bool _isInitialized = false;

  /// يتم استدعاؤها فور تسجيل دخول المستخدم
  /// [userId] : يجب أن يكون baseUserId (من جدول Users في الـ DB)
  /// [userName] : الاسم الظاهر في واجهة المكالمة
  Future<void> init({
    required String userId,
    required String userName,
  }) async {
    if (_isInitialized) return;

    debugPrint('📡 ZegoCallService: Initializing for [$userId] ($userName)');

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: kZegoAppID,
      appSign: kZegoAppSign,
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final isVideo = data.type == ZegoCallInvitationType.videoCall;
        final isGroup = data.invitees.length > 1;

        if (isGroup) return ZegoUIKitPrebuiltCallConfig.groupVideoCall();
        return isVideo
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
      },
    );

    // ✅ الطريقة الصحيحة في v4.22.2 لعرض شاشة الرنين فوق أي صفحة
    // setNavigatorKey تقوم داخلياً بإعداد contextQuery تلقائياً
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

    _isInitialized = true;
    debugPrint('✅ ZegoCallService: Ready! User [$userId] is now reachable.');
  }

  /// يتم استدعاؤها عند تسجيل الخروج لفصل المستخدم عن سيرفرات Zego
  Future<void> uninit() async {
    if (!_isInitialized) return;
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _isInitialized = false;
    debugPrint('🔌 ZegoCallService: Disconnected.');
  }

  bool get isInitialized => _isInitialized;
}
