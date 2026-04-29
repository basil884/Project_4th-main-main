import 'package:dio/dio.dart';

class ApiClient {
  // 1. تعريف الكائن ليكون متاحاً على مستوى التطبيق (Singleton)
  static late Dio _dio;

  // 2. دالة التهيئة (نستدعيها مرة واحدة في main.dart)
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            'https://your-nodejs-server.com/api/', // 🔥 الرابط الأساسي للسيرفر
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 15), // أقصى مدة للاتصال
        receiveTimeout: const Duration(seconds: 15), // أقصى مدة لاستلام الرد
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 3. إضافة الـ Interceptor (هذا سيطبع لك الريكويست والرد في الكونسول تلقائياً بدون print يدوية!)
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true, // يطبع البيانات المرسلة
        responseHeader: false,
        responseBody: true, // يطبع رد السيرفر
        error: true,
      ),
    );
  }

  // 4. دالة موحدة لإرسال طلبات الـ POST
  static Future<Response> postData({
    required String endpoint,
    required dynamic data, // يمكن أن يكون Map أو FormData
    String? token, // للمستقبل إذا احتجت تمرير توكن
  }) async {
    // إذا كان هناك توكن، نضيفه للهيدر
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }

    // نرسل الطلب (نكتب فقط نهاية الرابط لأن الـ baseUrl مكتوب فوق)
    return await _dio.post(endpoint, data: data);
  }

  // دالة موحدة لإرسال طلبات الـ GET
  static Future<Response> getData({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }
}
