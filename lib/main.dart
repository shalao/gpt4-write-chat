import 'package:flutter/material.dart';
import 'package:chat_app/api.dart';
import 'package:chat_app/typewriter_tween.dart';
import 'package:chat_app/chat_message.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat App')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
                keyboardAppearance: Brightness.dark,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null),
            ),
          ],
        ),
      ),
    );
  }

void _handleSubmitted(String text) async {
  _textController.clear();
  setState(() {
    _isComposing = false;
  });

  AnimationController animationController = AnimationController(
    duration: Duration(milliseconds: 200),
    vsync: this,
  );

  ChatMessage message = ChatMessage(
    content: text,
    animationController: animationController,
  );
  setState(() {
    _messages.insert(0, message);
  });
  animationController.forward();

  // Listen to the stream returned by sendMessage
  Stream<String> responseStream = ChatApi().sendMessage(text, vsync: this);

  responseStream.listen(
    (String responseContent) {
      print('Response: $responseContent');
      AnimationController responseAnimationController = AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this,
      );

      ChatMessage responseMessage = ChatMessage(
        content: responseContent,
        animationController: responseAnimationController,
      );
      setState(() {
        _messages.insert(0, responseMessage);
      });
      responseAnimationController.forward();
    },
    onError: (error) {
      print('Error: $error');
    },
  );
}



}