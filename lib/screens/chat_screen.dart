import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../services/gemini_service.dart';
import '../themes/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': "Hello! I've analyzed your notes from the 'Q4 Strategy Meeting'. Would you like me to extract the action items or summarize the key decisions for you?",
      'time': '10:24 AM'
    }
  ];
  final GeminiService _geminiService = GeminiService();

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;
    
    final userText = _controller.text;
    setState(() {
      _messages.add({
        'isUser': true,
        'text': userText,
        'time': 'Just now',
      });
      _controller.clear();
    });

    // Simple context gathering
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final contextData = notesProvider.notes.take(5).map((e) => e.content).join('\n');

    final response = await _geminiService.askAI(userText, contextData);
    
    setState(() {
      _messages.add({
        'isUser': false,
        'text': response ?? 'Sorry, I couldn\'t process that.',
        'time': 'Just now',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Column(
          children: [
             CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryContainer,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 30),
            ),
            SizedBox(height: 12),
            Text('How can I help you today?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('I\'m your intelligent assistant, ready to help.', style: TextStyle(color: AppTheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return _buildMessage(msg['text'], msg['isUser'], msg['time']);
            },
          ),
        ),
        _buildInput(),
      ],
    );
  }

  Widget _buildMessage(String text, bool isUser, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? Colors.white.withOpacity(0.05) : AppTheme.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 16),
              ),
              border: Border.all(color: Colors.white10),
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Text(text, style: const TextStyle(color: AppTheme.onSurface, height: 1.4)),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 10, color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: AppTheme.onSurface),
                decoration: const InputDecoration(
                  hintText: 'Ask Gemini something...',
                  hintStyle: TextStyle(color: Colors.white10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.primaryContainer,
            child: IconButton(
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
              onPressed: _sendMessage,
            ),
          )
        ],
      ),
    );
  }
}
