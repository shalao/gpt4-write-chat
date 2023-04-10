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
  
  /*
   处理发送消息：
   desc:先检查输入的文本是否为空字符。如果是，则不会发送消息，而是返回。否则，它将创建一个新的 ChatMessage 对象，并将其添加到 _messages 列表中，以便在屏幕上显示。然后，它会调用 ChatApi().sendMessage 方法发送消息，并将其返回的流储存在 responseStream 中。接下来，它会创建一个响应消息 ChatMessage 对象，并将其添加到 _messages 列表中。最后，它会监听 responseStream，并在收到响应消息时更新 responseMessage 对象的内容。
   */
  void _handleSubmitted(String text) async {
     // 过滤空字符
    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    AnimationController animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    // 创建发送消息的 ChatMessage 对象，并将其添加到 _messages 列表中
    ChatMessage message = ChatMessage(
      initialContent: text,
      animationController: animationController,
      isSender: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    animationController.forward();

    // Listen to the stream returned by sendMessage
    Stream<String> responseStream = ChatApi().sendMessage(text, vsync: this);
    
    // 创建响应消息的 ChatMessage 对象，并将其添加到 _messages 列表中
    ChatMessage responseMessage = ChatMessage(
      initialContent: '',
      animationController: animationController,
      isSender: false,
    );

    setState(() {
      _messages.insert(0, responseMessage);
    });

    // 监听响应流，并在接收到响应消息时更新 UI
    responseStream.listen(
      (String content) {
       
        //获取当前时间
        DateTime now = DateTime.now();
        //打印内容并显示当前时间
        print('Response time :$now  conten $content');
         // 更新响应消息的内容
        setState(() {
          responseMessage.content.value += content;
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }
  
}
