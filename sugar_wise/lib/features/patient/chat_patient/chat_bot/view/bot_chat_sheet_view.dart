import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // 🚨 تأكد من استيراد هذه المكتبة

// ======================================================================
// 🔥 3. شاشة الشات بوت المنبثقة (النسخة الحقيقية المربوطة بالذكاء الاصطناعي)
// ======================================================================
class BotChatSheet extends StatefulWidget {
  const BotChatSheet({super.key});

  @override
  State<BotChatSheet> createState() => _BotChatSheetState();
}

class _BotChatSheetState extends State<BotChatSheet> {
  final TextEditingController _botMessageController = TextEditingController();
  final ScrollController _botScrollController = ScrollController();

  List<Map<String, dynamic>> botMessages = [];

  // 🔥 متغيرات الذكاء الاصطناعي (Gemini)
  // ضع الـ API Key الخاص بك هنا (مؤقتاً للتجربة، وفي الإنتاج يفضل وضعه في ملف .env)
  final String apiKey = "";
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  bool _isTyping = false; // لإظهار مؤشر التحميل بينما البوت يفكر

  @override
  void initState() {
    super.initState();
    _initializeChatbot();
  }

  // 🧠 دالة تشغيل عقل البوت وتغذيته بـ "بياناتك الخاصة"
  void _initializeChatbot() {
    // 💡 هنا تضع كل بياناتك الخاصة التي تريد أن يعرفها البوت!
    // 🧠 تعليمات النظام المُنظمة والمهندسة لسرعة وكفاءة أعلى
    final systemInstruction = Content.system('''
الهوية والدور:
أنت "سكر" (Sugar)، المساعد الطبي الذكي والودود الخاص بتطبيق "Sugar Wise". مهمتك الأساسية هي مساعدة المرضى والإجابة على استفساراتهم بأسلوب مهذب ومطمئن.

المعلومات الأساسية للتطبيق:
- مواعيد العيادة: من الأحد للخميس، من 10 صباحاً حتى 8 مساءً.
- حجز موعد: اطلب من المريض التوجه إلى "قسم الحجوزات" في الصفحة الرئيسية للتطبيق.
- الدعم الفني: عبر الواتساب على الرقم 01005550944.
المعلومات الأساسية لمشرفين التطبيق:
-دكتور حاتم الخشاب والمعيدة مريم حسين 
معلومات الفريق:
- الفريق الطبي (يتوسع باستمرار): د. محمد عبدالقادر (صيدلي، 19 سنة، من قنا، يدرس بصيدلة بني سويف)، ود. عمر خالد.
- فريق تطوير التطبيق: باسل أشرف (مطور موبايل)، يوسف خطاب (مطور ويب)، روان يسري (مطور ويب وتصميم)، مريم مصطفى (مطور موبايل).

القواعد الصارمة (يجب الالتزام بها دائماً):
1. لا للتشخيص: يُمنع منعاً باتاً كتابة وصفات طبية أو تشخيص قاطع. وجه المريض لزيارة الطبيب للتأكد.
2. الإيجاز: ردودك يجب أن تكون مختصرة وواضحة جداً (لا تتجاوز 2 إلى 3 جمل في كل رد).
3. حدود المعرفة: إذا سألك المريض عن شيء خارج معلوماتك، اعتذر بلباقة، وقل أنك لست متأكداً، ووجهه للطبيب أو الدعم.
4. الأمان النفسي: كن محترماً ومتفهماً، وتجنب أي لغة قد تسبب قلقاً للمريض.
    ''');

    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      systemInstruction: systemInstruction,
    ); // بدء جلسة الشات (لكي يتذكر البوت سياق المحادثة السابقة)
    _chatSession = _model.startChat();

    // رسالة الترحيب الأولى
    botMessages.add({
      "text":
          "مرحباً! أنا المساعد الذكي الخاص بتطبيق Sugar Wise 🤖، كيف يمكنني مساعدتك اليوم؟",
      "isMe": false,
    });
  }

  // 🚀 دالة إرسال الرسالة إلى Gemini واستقبال الرد
  Future<void> _sendBotMessage() async {
    final message = _botMessageController.text.trim();
    if (message.isEmpty || _isTyping) return; // منع الإرسال إذا كان البوت يكتب

    setState(() {
      botMessages.add({"text": message, "isMe": true});
      _isTyping = true; // إظهار أن البوت يفكر
    });

    _botMessageController.clear();
    _scrollToBottom();

    try {
      // إرسال الرسالة الحقيقية لـ Gemini
      final response = await _chatSession.sendMessage(Content.text(message));

      if (mounted) {
        setState(() {
          botMessages.add({
            "text": response.text ?? "عذراً، لم أستطع صياغة الرد.",
            "isMe": false,
          });
          _isTyping = false;
        });
      }
    } catch (e) {
      // 🔥 طباعة الخطأ في الكونسول لمعرفته بالتحديد
      debugPrint("🤖 Gemini API EXACT ERROR: $e");

      if (mounted) {
        setState(() {
          botMessages.add({
            // 🔥 عرض الخطأ أمامك في الشات مباشرة
            "text": "خطأ 🔴: ${e.toString().split('\n').first}",
            "isMe": false,
          });
          _isTyping = false;
        });
      }
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_botScrollController.hasClients) {
        _botScrollController.animateTo(
          _botScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF6B48FF),
                      child: Icon(Icons.smart_toy, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Sugar Assistant",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // ---------------- CHAT LIST ----------------
          Expanded(
            child: ListView.builder(
              controller: _botScrollController,
              padding: const EdgeInsets.all(15),
              itemCount: botMessages.length,
              itemBuilder: (context, index) {
                final msg = botMessages[index];
                final isMe = msg["isMe"];
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF6B48FF) : cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: Radius.circular(isMe ? 15 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 15),
                      ),
                    ),
                    child: Text(
                      msg["text"],
                      style: TextStyle(
                        color: isMe
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔥 إظهار مؤشر تحميل صغير إذا كان البوت يفكر
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Bot is typing...",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          // ---------------- INPUT AREA ----------------
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _botMessageController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ask the bot...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey,
                        ),
                      ),
                      onSubmitted: (_) => _sendBotMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: _isTyping
                      ? Colors.grey
                      : const Color(0xFF6B48FF),
                  child: IconButton(
                    icon: _isTyping
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _isTyping ? null : _sendBotMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
