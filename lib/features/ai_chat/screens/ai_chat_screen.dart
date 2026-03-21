import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/features/ai_chat/providers/chat_provider.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _showSuggestions = true;
  DateTime? _selectedDateTime;

  // Suggested questions shown before the user starts typing
  static const List<String> _suggestions = [
    '🐟 What fish are in season right now?',
    '🪝 What bait is best for catfish?',
    '🌊 Best time of day to fish?',
    '📏 What is the legal catch size for tilapia?',
    '🤿 How do I release a fish safely?',
    '🐠 How can I identify a pregnant fish?',
    '🐡 What lures work best in freshwater?',
    '🌧️ Does rain affect fishing?',
  ];

  void _sendMessage([String? overrideText]) {
    final text = (overrideText ?? _controller.text).trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text, customDateTime: _selectedDateTime);
    _controller.clear();
    setState(() {
      _showSuggestions = false;
      _selectedDateTime = null; // Reset after sending
    });

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSuggestionTapped(String suggestion) {
    // Strip the emoji prefix before sending
    final clean = suggestion.replaceFirst(RegExp(r'^[\S]+ '), '');
    _sendMessage(clean);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: OcevaraAppBar(
        title: 'Fishing Expert',
        subtitle: 'Powered by Ocevara AI',
        actions: [
          IconButton(
            icon: Icon(
              Icons.event_available,
              color: _selectedDateTime != null ? AppColors.primaryTeal : AppColors.getTextPrimary(context),
            ),
            onPressed: _showDateTimePicker,
            tooltip: 'Plan for a specific time',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Chat messages ──────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),

          // ── Suggestion chips (visible until first message sent) ────
          if (_showSuggestions) _buildSuggestionStrip(),

          // ── Text input area ────────────────────────────────────────
          _buildInputArea(),
        ],
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Widget _buildSuggestionStrip() {
    return Container(
      color: AppColors.getScaffoldBackground(context),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'Suggested questions — tap to ask',
              style: GoogleFonts.lato(
                fontSize: 11,
                color: AppColors.getTextSecondary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = _suggestions[i];
                return GestureDetector(
                  onTap: () => _onSuggestionTapped(s),
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.getCardBackground(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryTeal.withOpacity(0.1)),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: AppColors.getTextPrimary(context),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    final isTyping = !msg.isUser && msg.text == '...';
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primaryNavy : AppColors.getCardBackground(context),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                msg.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight:
                msg.isUser ? Radius.zero : const Radius.circular(16),
          ),
          border: msg.isUser ? null : Border.all(color: AppColors.primaryTeal.withOpacity(0.1)),
        ),
        child: isTyping
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Typing',
                      style: GoogleFonts.lato(
                          color: AppColors.getTextSecondary(context), fontSize: 13)),
                  const SizedBox(width: 4),
                  const _TypingDots(),
                ],
              )
            : Text(
                msg.text,
                style: GoogleFonts.lato(
                  color: msg.isUser ? Colors.white : AppColors.getTextPrimary(context),
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
  Widget _buildInputArea() {
    return Column(
      children: [
        if (_selectedDateTime != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryTeal.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                Text(
                  'Planning for: ${DateFormat('MMM d, HH:mm').format(_selectedDateTime!)}',
                  style: GoogleFonts.lato(
                      fontSize: 12,
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _selectedDateTime = null),
                  child:
                      Icon(Icons.close, size: 16, color: AppColors.primaryTeal),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(context),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask about fish, lures, or locations...',
                      hintStyle: GoogleFonts.lato(
                          color: AppColors.getTextSecondary(context)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.getScaffoldBackground(context),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    onChanged: (v) {
                      if (v.isNotEmpty && _showSuggestions) {
                        setState(() => _showSuggestions = false);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Three animated bouncing dots shown while AI is generating a response.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Each dot peaks at a different phase
            final phase = (t - i * 0.2).clamp(0.0, 1.0);
            final dy = -4.0 * (phase < 0.5 ? phase : 1 - phase) * 2;
            return Transform.translate(
              offset: Offset(0, dy),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.getTextSecondary(context),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
