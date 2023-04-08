import 'package:flutter/material.dart';
import 'package:chat_app/typewriter_tween.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage extends StatelessWidget {
  // final ValueNotifier<String> content;
  final ValueNotifier<String> content;
  final String authorName;
  final AnimationController animationController;

  ChatMessage({
    required this.content,
    required this.authorName,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text('AI')), // or use your authorName
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('AI',
                      style: Theme.of(context)
                          .textTheme
                          .headline4), // or use your authorName
                  ValueListenableBuilder<String>(
                    valueListenable: content,
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      return MarkdownBody(data: value);
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
}

class TypewriterText extends StatelessWidget {
  final String text;
  final double progress;
  TypewriterText({required this.text, required this.progress});
  @override
  Widget build(BuildContext context) {
    return Text(
      text.substring(0, (text.length * progress).round()),
      style: TextStyle(fontSize: 16.0),
    );
  }
}
