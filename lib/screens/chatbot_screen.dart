import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../data/offline_disease_db.dart';
import '../data/symptom_checker_model.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Each message: { "type": "text_user"|"text_bot", "content": "...", "isTyping": bool }
  List<Map<String, dynamic>> messages = [];

  bool _isLoading = false;
  bool _offlineMode = false; // ← Toggle for offline mode

  // Typewriter state
  Timer? _typeTimer;
  String _typingBuffer = '';
  int _typingIndex = 0;
  bool _isTyping = false;

  final String apiKey = "AIzaSyCJaTzIZyqJ_TqLyzXCkhuaLodESllcaM4";

  // ─── Online: Gemini API ──────────────────────────────────────────────────
  Future<String> sendMessageToGemini(String userMessage) async {
    const String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent";

    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "You are ARTICUNO, a healthcare assistant for rural areas. "
                      "Reply in a clear, natural way. Keep answers concise. "
                      "Do not use bold, italics, special symbols (*, #, _, backticks), or code formatting. "
                      "Focus on health-related queries, disease symptoms, precautions, and remedies. "
                      "You can use bullet points where needed.",
                },
                {"text": userMessage},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.4,
            "maxOutputTokens": 200,
            "topP": 0.9,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"] ??
            "No response";
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Unable to connect. Try Offline Mode.";
    }
  }

  // ─── Offline: local disease DB lookup ───────────────────────────────────
  String queryOfflineDB(String userMessage) {
    final disease = findDiseaseByQuery(userMessage);
    if (disease != null) {
      return formatDiseaseResponse(disease);
    }
    return "I couldn't find information about that in offline mode.\n"
        "For internet-based answers, switch to Online Mode.";
  }

  // ─── Typewriter animation ────────────────────────────────────────────────
  void _typewriterReveal(String fullText) {
    _isTyping = true;
    _typingBuffer = '';
    _typingIndex = 0;

    // Add a bot message entry that will be updated character by character
    setState(() {
      messages.add({"type": "text_bot", "content": "", "isTyping": true});
    });

    final int botIndex = messages.length - 1;

    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_typingIndex < fullText.length) {
        _typingBuffer += fullText[_typingIndex];
        _typingIndex++;
        setState(() {
          messages[botIndex]["content"] = _typingBuffer;
        });
        _scrollToBottom();
      } else {
        timer.cancel();
        setState(() {
          messages[botIndex]["isTyping"] = false;
          _isTyping = false;
          _isLoading = false;
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Send handler ────────────────────────────────────────────────────────
  Future<void> _handleSend() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty || _isLoading || _isTyping) return;

    setState(() {
      messages.add({
        "type": "text_user",
        "content": userMessage,
        "isTyping": false,
      });
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Run the fetch + mandatory 7-second loading timer in parallel.
    // Response only shows after BOTH complete (whichever takes longer).
    final results = await Future.wait([
      _offlineMode
          ? Future.value(queryOfflineDB(userMessage))
          : sendMessageToGemini(userMessage),
      Future.delayed(const Duration(seconds: 7), () => ''), // 7s minimum wait
    ]);

    final botReply = results[0]; // first result is always the actual reply
    _typewriterReveal(botReply);
  }

  // ─── Symptom Checker bottom sheet ────────────────────────────────────────
  void _openSymptomChecker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _SymptomCheckerSheet(
          onPredict: (Set<String> selectedIds) async {
            Navigator.pop(ctx); // close sheet

            // Build user-facing message that lists selected symptoms
            final labels = allSymptoms
                .where((s) => selectedIds.contains(s.id))
                .map((s) => s.label)
                .join(', ');

            setState(() {
              messages.add({
                "type": "text_user",
                "content": "Symptom Check: $labels",
                "isTyping": false,
              });
              _isLoading = true;
            });
            _scrollToBottom();

            // 7-second loader + prediction run in parallel
            final predictions = predictDiseases(selectedIds);
            final response = formatPredictionResponse(selectedIds, predictions);

            await Future.delayed(const Duration(seconds: 7));

            _typewriterReveal(response);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Mode badge ─────────────────────────────────────────────────────────
  Widget _modeBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _offlineMode
            ? Colors.orange.withOpacity(0.15)
            : Colors.teal.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _offlineMode ? Colors.orange : const Color(0xFF26A69A),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _offlineMode ? Icons.wifi_off : Icons.wifi,
            size: 13,
            color: _offlineMode ? Colors.orange : const Color(0xFF26A69A),
          ),
          const SizedBox(width: 5),
          Text(
            _offlineMode ? "Offline" : "Online",
            style: TextStyle(
              fontSize: 12,
              color: _offlineMode ? Colors.orange : const Color(0xFF26A69A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Offline mode toggle button ──────────────────────────────────────────
  Widget _offlineToggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() => _offlineMode = !_offlineMode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _offlineMode
                ? Colors.orange.shade800
                : Colors.teal.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
            content: Row(
              children: [
                Icon(
                  _offlineMode ? Icons.wifi_off : Icons.wifi,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _offlineMode
                      ? "Offline Mode ON — using local disease database"
                      : "Online Mode — using ARTICUNO AI",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _offlineMode
                ? [Colors.orange.shade800, Colors.deepOrange.shade700]
                : [const Color(0xFF1A6B62), const Color(0xFF26A69A)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (_offlineMode ? Colors.orange : Colors.teal).withOpacity(
                0.35,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _offlineMode ? Icons.wifi_off : Icons.wifi,
              size: 15,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              _offlineMode ? "Go Online" : "Go Offline",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Message bubble ──────────────────────────────────────────────────────
  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg["type"] == "text_user";
    final content = msg["content"] as String;
    final isTypingNow = msg["isTyping"] as bool? ?? false;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.80,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFF26A69A).withOpacity(0.18)
              : (_offlineMode
                    ? Colors.orange.withOpacity(0.10)
                    : Colors.green.withOpacity(0.12)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 2),
            bottomRight: Radius.circular(isUser ? 2 : 14),
          ),
          border: Border.all(
            color: isUser
                ? const Color(0xFF26A69A).withOpacity(0.25)
                : (_offlineMode
                      ? Colors.orange.withOpacity(0.25)
                      : Colors.teal.withOpacity(0.20)),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (isTypingNow) ...[const SizedBox(height: 4), _buildCursor()],
          ],
        ),
      ),
    );
  }

  // Blinking cursor shown during typewriter animation
  Widget _buildCursor() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (ctx, value, _) {
        return Opacity(
          opacity: value > 0.5 ? 1.0 : 0.0,
          child: Container(
            width: 2,
            height: 14,
            color: _offlineMode ? Colors.orange : const Color(0xFF26A69A),
          ),
        );
      },
      onEnd: () => setState(() {}), // keeps rebuilding for blink effect
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: false,
        title: Row(
          children: [
            const Text(
              "ARTICUNO",
              style: TextStyle(
                color: Color(0xFF26A69A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 12.0,
                    color: Color(0xFF26A69A),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _modeBadge(),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _offlineToggleButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline mode info banner
          if (_offlineMode)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              color: Colors.orange.withOpacity(0.10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Offline Mode: search your problem ",
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.health_and_safety,
                          size: 80,
                          color: Colors.teal.withOpacity(0.25),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Ask ARTICUNO about your health",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _offlineMode
                              ? "Offline: type a disease name to search"
                              : "Online: powered by Gemini AI",
                          style: TextStyle(
                            color: _offlineMode
                                ? Colors.orange.withOpacity(0.6)
                                : Colors.teal.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(messages[index]);
                    },
                  ),
          ),

          // Loading indicator (only shown while waiting for API, not during typewriter)
          if (_isLoading && !_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _offlineMode
                          ? Colors.orange
                          : const Color(0xFF26A69A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _offlineMode
                        ? "Searching disease database..."
                        : "ARTICUNO is thinking...",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),

      // Floating action button for symptom checker (Offline only)
      floatingActionButton: _offlineMode
          ? FloatingActionButton.extended(
              onPressed: _openSymptomChecker,
              backgroundColor: Colors.orange.shade800,
              icon: const Icon(Icons.medical_services, color: Colors.white),
              label: const Text(
                'Symptom Checker',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,

      // Bottom input bar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: const Border(
              top: BorderSide(color: Colors.white12, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onSubmitted: (_) => _handleSend(),
                  decoration: InputDecoration(
                    hintText: _offlineMode
                        ? "Type disease or symptom..."
                        : "Describe your symptoms...",
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF111111),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: _offlineMode
                            ? Colors.orange.withOpacity(0.30)
                            : Colors.teal.withOpacity(0.20),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: _offlineMode
                            ? Colors.orange
                            : const Color(0xFF26A69A),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _handleSend,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _offlineMode
                          ? [Colors.orange.shade700, Colors.deepOrange.shade600]
                          : [const Color(0xFF1A6B62), const Color(0xFF26A69A)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_offlineMode ? Colors.orange : Colors.teal)
                            .withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Symptom Checker Bottom Sheet Widget ──────────────────────────────────
class _SymptomCheckerSheet extends StatefulWidget {
  final Function(Set<String>) onPredict;

  const _SymptomCheckerSheet({required this.onPredict});

  @override
  State<_SymptomCheckerSheet> createState() => _SymptomCheckerSheetState();
}

class _SymptomCheckerSheetState extends State<_SymptomCheckerSheet> {
  final Set<String> _selectedIds = {};

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Widget _buildGroup(String title, String category, Color color) {
    final list = allSymptoms.where((s) => s.category == category).toList();
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: list.map((s) {
            final isSelected = _selectedIds.contains(s.id);
            return GestureDetector(
              onTap: () => _toggle(s.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  s.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Symptom Checker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Symptom list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  "Select all the symptoms you are currently experiencing:",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),

                _buildGroup("FEVER", "fever", Colors.redAccent),
                _buildGroup("RESPIRATORY", "respiratory", Colors.lightBlue),
                _buildGroup("GUT & DIGESTION", "gut", Colors.orange),
                _buildGroup("SKIN", "skin", Colors.pinkAccent),
                _buildGroup("EYES & E.N.T", "ent", Colors.purpleAccent),
                _buildGroup("HEAD & NEURO", "neuro", Colors.deepPurpleAccent),
                _buildGroup("HEART & METABOLIC", "cardio", Colors.red),
                _buildGroup("GENERAL/BODY", "general", Colors.teal),

                const SizedBox(height: 80), // padding for bottom button
              ],
            ),
          ),

          // Bottom sticky button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  "${_selectedIds.length} selected",
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _selectedIds.isEmpty
                      ? null
                      : () => widget.onPredict(_selectedIds),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    disabledBackgroundColor: Colors.white12,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Check Symptoms",
                        style: TextStyle(
                          color: _selectedIds.isEmpty
                              ? Colors.white38
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: _selectedIds.isEmpty
                            ? Colors.white38
                            : Colors.white,
                      ),
                    ],
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
