import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat/chat_bloc.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_models.dart';
import '../theme/app_colors.dart';
import '../widgets/app_section_header.dart';
import '../widgets/chat_bubble.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiChat),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'close') {
                context.read<ChatBloc>().add(ChatClosed());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'close', child: Text(l10n.closeSession)),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.riskHigh,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          List<ChatMessage> messages = [];
          bool isLoading = false;
          bool isIngesting = false;

          if (state is ChatInitial) {
            // Show empty state with prompt to start new session
            return _buildEmptyState(context, l10n);
          } else if (state is ChatIngesting) {
            messages = state.messages;
            isIngesting = true;
          } else if (state is ChatReady) {
            messages = state.messages;
          } else if (state is ChatAnswering) {
            messages = state.messages;
            isLoading = true;
          } else if (state is ChatError) {
            messages = state.messages;
            isLoading = false;
          }

          return Column(
            children: [
              if (messages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: AppSectionHeader(
                    title: l10n.chatSession,
                    subtitle: isIngesting
                        ? l10n.preparingRag
                        : l10n.askAiSummarizeNegotiate,
                  ),
                ),
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyMessages(context, l10n)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: messages.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return const _TypingIndicator();
                          }
                          final msg = messages[index];
                          return ChatBubble(
                            message: msg.text,
                            isUser: msg.isUser,
                            time: _formatTime(msg.sentAt),
                            sources: msg.sources,
                          );
                        },
                      ),
              ),
              _ChatInput(
                onSend: (text) {
                  context.read<ChatBloc>().add(QuestionSubmitted(text));
                },
                enabled: !isLoading && !isIngesting,
                l10n: l10n,
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text(
              l10n.noActiveChatSession,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.startNewSessionPrompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<ChatBloc>().add(ChatStarted([]));
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.startNewSession),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildEmptyMessages(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message_outlined, size: 64, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text(
              l10n.noMessagesYet,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.askQuestionToStart,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
        ),
        child: const SizedBox(
          width: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Dot(delay: 0),
              _Dot(delay: 150),
              _Dot(delay: 300),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatefulWidget {
  final void Function(String) onSend;
  final bool enabled;
  final AppLocalizations l10n;

  const _ChatInput({
    required this.onSend,
    required this.enabled,
    required this.l10n,
  });

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: widget.l10n.typeQuestionPlaceholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: widget.enabled ? _submit : null,
            icon: const Icon(Icons.send_rounded),
            color: Theme.of(context).colorScheme.primary,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}