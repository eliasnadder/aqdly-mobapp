import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_section_header.dart';
import '../widgets/chat_bubble.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Interface'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: AppSectionHeader(
              title: 'Chat Session',
              subtitle: 'Ask the AI to summarize or negotiate clauses.',
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                ChatBubble(
                  message:
                      'Summarize the liability clause for the new supplier contract.',
                  isUser: true,
                  time: '09:14 AM',
                ),
                ChatBubble(
                  message:
                      'Clause 6.2 caps liability at 2.5x annual fees and excludes indirect damages. Recommend negotiating down to 1.5x.',
                  isUser: false,
                  time: '09:15 AM',
                ),
                ChatBubble(
                  message:
                      'Highlight any GDPR or data processing gaps and suggest fixes.',
                  isUser: true,
                  time: '09:16 AM',
                ),
                ChatBubble(
                  message:
                      'Data processing addendum lacks breach notification timeline. Add 72-hour notification requirement and specify subprocessors.',
                  isUser: false,
                  time: '09:17 AM',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.surfaceVariant)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a question for the AI assistant',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
