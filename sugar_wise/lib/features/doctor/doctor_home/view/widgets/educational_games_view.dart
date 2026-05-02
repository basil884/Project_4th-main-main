import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

class EducationalGamesView extends StatefulWidget {
  const EducationalGamesView({super.key});

  @override
  State<EducationalGamesView> createState() => _EducationalGamesViewState();
}

class _EducationalGamesViewState extends State<EducationalGamesView> {
  String _activeTab = 'memory_match';

  // Memory Match Logic
  final List<Map<String, dynamic>> _gameIcons = [
    {
      'icon': Icons.psychology_outlined,
      'color': const Color(0xFFD946EF),
    }, // Brain
    {
      'icon': Icons.vaccines_outlined,
      'color': const Color(0xFF64748B),
    }, // Syringe
    {'icon': Icons.favorite_border, 'color': const Color(0xFFEF4444)}, // Heart
    {
      'icon': Icons.medication_liquid_outlined,
      'color': const Color(0xFFF59E0B),
    }, // Medicine
    {
      'icon': Icons.medical_services_outlined,
      'color': const Color(0xFF10B981),
    }, // First Aid
    {'icon': Icons.air, 'color': const Color(0xFF3B82F6)}, // Wind
  ];

  late List<Map<String, dynamic>> _items;
  late List<bool> _flipped;
  late List<bool> _matched;
  int? _prevIndex;
  int _moves = 0;
  bool _wait = false;
  bool _isWon = false;

  // Trivia Logic
  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _triviaQuestions = [
    {
      'question': 'trivia_q1'.tr(),
      'options': [
        'trivia_q1_o1'.tr(),
        'trivia_q1_o2'.tr(),
        'trivia_q1_o3'.tr(),
        'trivia_q1_o4'.tr(),
      ],
      'answer': 1,
    },
    {
      'question': 'trivia_q2'.tr(),
      'options': [
        'trivia_q2_o1'.tr(),
        'trivia_q2_o2'.tr(),
        'trivia_q2_o3'.tr(),
        'trivia_q2_o4'.tr(),
      ],
      'answer': 0,
    },
    {
      'question': 'trivia_q3'.tr(),
      'options': [
        'trivia_q3_o1'.tr(),
        'trivia_q3_o2'.tr(),
        'trivia_q3_o3'.tr(),
        'trivia_q3_o4'.tr(),
      ],
      'answer': 2,
    },
  ];
  int? _selectedTriviaOption;
  int _quizScore = 0;
  bool _showQuizResults = false;

  @override
  void initState() {
    super.initState();
    _items = [..._gameIcons, ..._gameIcons];
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _items.shuffle();
      _flipped = List.generate(_items.length, (_) => false);
      _matched = List.generate(_items.length, (_) => false);
      _prevIndex = null;
      _moves = 0;
      _wait = false;
      _isWon = false;
    });
  }

  void _handleCardTap(int index) {
    if (_wait || _flipped[index] || _matched[index] || _isWon) return;

    setState(() {
      _flipped[index] = true;
      if (_prevIndex == null) {
        _prevIndex = index;
      } else {
        _moves++;
        if (_items[_prevIndex!]['icon'] == _items[index]['icon']) {
          _matched[_prevIndex!] = true;
          _matched[index] = true;
          _prevIndex = null;
          if (_matched.every((m) => m)) {
            _isWon = true;
          }
        } else {
          _wait = true;
          Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              _flipped[_prevIndex!] = false;
              _flipped[index] = false;
              _prevIndex = null;
              _wait = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "health_wellness_hub".tr(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "wellness_hub_desc".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Tabs
            _buildTabItem(
              "memory_match",
              Icons.settings_suggest,
              const Color(0xFF2563EB),
            ),
            const SizedBox(height: 15),
            _buildTabItem(
              "health_trivia",
              Icons.quiz_outlined,
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 15),
            _buildTabItem(
              "relaxation",
              Icons.self_improvement,
              const Color(0xFFA855F7),
            ),
            const SizedBox(height: 30),

            // Game Area
            if (_activeTab == 'memory_match') _buildMemoryMatchGame(),
            if (_activeTab == 'health_trivia') _buildHealthTriviaGame(),
            if (_activeTab == 'relaxation') _buildRelaxationSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  bool _isBreathing = false;
  String _breathingText = "Ready";
  Timer? _breathingTimer;

  Widget _buildRelaxationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9333EA), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            "stress_relief".tr(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "deep_breathing".tr(),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 50),

          // Animated Circle
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer rings for effect
              if (_isBreathing) ...[
                _buildBreathingRing(220, 0.1),
                _buildBreathingRing(180, 0.2),
              ],
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _breathingText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),
          SizedBox(
            width: 150, // Smaller button as per screenshot
            height: 55,
            child: ElevatedButton(
              onPressed: _toggleBreathing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF9333EA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),

              child: Text(
                _isBreathing ? "stop".tr() : "start".tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "session_length".tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingRing(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }

  void _toggleBreathing() {
    setState(() {
      _isBreathing = !_isBreathing;
      if (_isBreathing) {
        _startBreathingCycle();
      } else {
        _breathingTimer?.cancel();
        _breathingText = "ready".tr();
      }
    });
  }

  void _startBreathingCycle() {
    int step = 0;
    const phases = ["inhale", "hold", "exhale", "hold"];
    _breathingText = phases[0].tr();

    _breathingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_isBreathing) {
        timer.cancel();
        return;
      }
      setState(() {
        step = (step + 1) % phases.length;
        _breathingText = phases[step].tr();
      });
    });
  }

  Widget _buildTabItem(String title, IconData icon, Color color) {
    bool isSelected = _activeTab == title;
    return GestureDetector(
      onTap: () => setState(() {
        _activeTab = title;
        if (title == 'Health Trivia') {
          _currentQuestionIndex = 0;
          _selectedTriviaOption = null;
          _showQuizResults = false;
          _quizScore = 0;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white24
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    title == 'memory_match'
                        ? 'memory_match_desc'.tr()
                        : (title == 'health_trivia'
                              ? 'health_trivia_desc'.tr()
                              : 'relaxation_desc'.tr()),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isSelected ? Colors.white : Colors.grey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryMatchGame() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.grid_view_rounded,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "active_game".tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "moves_label".tr(args: [_moves.toString()]),
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          if (!_isWon)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _flipped[index] || _matched[index]
                          ? Colors.white
                          : const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2563EB),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _flipped[index] || _matched[index]
                        ? Icon(
                            _items[index]['icon'],
                            color: _items[index]['color'],
                            size: 30,
                          )
                        : const Text(
                            "?",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            )
          else
            Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _items[index]['icon'],
                        color: _items[index]['color'],
                        size: 30,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "great_job_brain".tr(),
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _resetGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "play_again".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (!_isWon) ...[
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => setState(() => _isWon = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "reset".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHealthTriviaGame() {
    if (_showQuizResults) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.school_outlined,
                  color: Color(0xFF1E293B),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "health_trivia".tr().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                color: Color(0xFF10B981),
                size: 45,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "you_scored".tr(
                args: [
                  _quizScore.toString(),
                  _triviaQuestions.length.toString(),
                ],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "thanks_learning".tr(),
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _showQuizResults = false;
                  _currentQuestionIndex = 0;
                  _selectedTriviaOption = null;
                  _quizScore = 0;
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "restart_quiz".tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final currentQuestion = _triviaQuestions[_currentQuestionIndex];
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF10B981), size: 24),
              const SizedBox(width: 10),
              Text(
                "health_trivia".tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            "question_count".tr(
              args: [
                (_currentQuestionIndex + 1).toString(),
                _triviaQuestions.length.toString(),
              ],
            ),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            currentQuestion['question'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 25),
          ...List.generate(currentQuestion['options'].length, (index) {
            String label = String.fromCharCode(65 + index);
            bool isSelected = _selectedTriviaOption == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTriviaOption = index),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF10B981)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          currentQuestion['options'][index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _selectedTriviaOption == null
                  ? null
                  : () {
                      if (_selectedTriviaOption == currentQuestion['answer']) {
                        _quizScore++;
                      }

                      if (_currentQuestionIndex < _triviaQuestions.length - 1) {
                        setState(() {
                          _currentQuestionIndex++;
                          _selectedTriviaOption = null;
                        });
                      } else {
                        setState(() {
                          _showQuizResults = true;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
              child: Text(
                _currentQuestionIndex == _triviaQuestions.length - 1
                    ? "Finish Quiz"
                    : "Submit Answer",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
