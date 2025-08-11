import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../widgets/build_dot_widget.dart';
import '../widgets/build_message_widget.dart';
import '../widgets/welcome_message_widget.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(Message(content: message, isUser: true));
      _isLoading = true;
      _messageController.clear(); // Inputu temizle
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add(Message(
            content: data['response'] ?? 'Üzgünüm, bir yanıt alamadım.',
            isUser: false,
          ));
        });
      } else {
        _showConnectionError();
      }
    } catch (e) {
      _showConnectionError();
    } finally {
      setState(() => _isLoading = false);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _showConnectionError() {
    setState(() {
      _messages.add(Message(
        content: 'Şu anda internete bağlı değilsiniz. Lütfen bağlantınızı kontrol edin.',
        isUser: false,
      ));
    });
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.only(right: 80, left: 16, top: 8, bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF374151),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildDot(0, this),
          SizedBox(width: 4),
          buildDot(1, this),
          SizedBox(width: 4),
          buildDot(2, this),
          SizedBox(width: 12),
          Text('Düşünüyor...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLogoGradient() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [Color(0xFF1E3A8A), Color(0xFF000000)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Gradient Logo
              Container(
                padding: EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogoGradient(),
                    SizedBox(width: 16),
                    Text(
                      'MoECatalyst',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Messages List with Gradient Logo
              Expanded(
                child: _messages.isEmpty
                    ? buildWelcomeMessage()
                    : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isLoading) {
                      return _buildLoadingIndicator();
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_messages[index].isUser) _buildLogoGradient(),
                        SizedBox(width: 8),
                        Expanded(child: buildMessage(_messages[index], context)),
                      ],
                    );
                  },
                ),
              ),

              // Input Area
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1F2937),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Color(0xFF4B5563)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              enabled: !_isLoading,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Mesajınızı buraya yazın...',
                                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              ),
                              onChanged: (text) {
                                setState(() {}); // Buton rengini dinamik güncelle
                              },
                              onSubmitted: (_) => _sendMessage(),
                              textInputAction: TextInputAction.send, // Enter tuşunu "Gönder" yapar
                              maxLines: null,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            child: InkWell(
                              onTap: _messageController.text.trim().isNotEmpty && !_isLoading
                                  ? _sendMessage
                                  : null,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _messageController.text.trim().isNotEmpty && !_isLoading
                                      ? Color(0xFF2563EB) // Aktifken mavi
                                      : Color(0xFF4B5563), // Pasifken gri
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.send,
                                  color: _messageController.text.trim().isNotEmpty && !_isLoading
                                      ? Colors.white
                                      : Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'MoECatalyst yapay zeka asistanınız',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}