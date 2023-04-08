// chat_message.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.initialContent = '',
      required this.animationController,
      this.isSender = false})
      : content = ValueNotifier(initialContent);

  final String initialContent;
  final ValueNotifier<String> content;
  final AnimationController animationController;
  final bool isSender;

  /*
  将 MarkdownBody 控件包裹在一个新的 Container 控件中，并设置了 padding 和 decoration 属性。decoration 属性的 color 根据 message.isSender 的值来确定。如果是发送者，颜色为 Color(0xFF0072EF)，否则颜色为 Color(0xFF313135)。这样，你的背景颜色应该仅填充文字长度
  */
 Widget _buildMessage(ChatMessage message) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: message.animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ValueListenableBuilder<String>(
                    valueListenable: message.content,
                    builder: (context, content, child) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: message.isSender
                              ? Color(0xFF0072EF)
                              : Color(0xFF313135),
                        ),
                        child: MarkdownBody(
                          data: content,
                          // ...其他Markdown样式设置
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessage(this);
  }
  
  /*
  @override
  Widget build(BuildContext context) {
    MarkdownStyleSheet markdownStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: TextStyle(fontSize: 18.0),
      code: TextStyle(fontSize: 16.0, backgroundColor: Color(0x5D3B5B)),
    );

    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: isSender
                      ? Color.fromRGBO(0, 114, 239, 1)
                      : Color.fromRGBO(49, 49, 53, 1),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: content,
                  builder: (context, value, child) {
                    return MarkdownBody(
                      data: value,
                      styleSheet: markdownStyleSheet,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  */
}
