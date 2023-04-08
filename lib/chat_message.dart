import 'package:flutter/material.dart';
import 'package:chat_app/typewriter_tween.dart';

class ChatMessage extends StatelessWidget {
  final ValueNotifier<String> content;
  final AnimationController animationController;

  ChatMessage({
    required String content,
    required this.animationController,
  }) : content = ValueNotifier<String>(content);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text('A')),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Chatbot', style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: ValueListenableBuilder<String>(
                      valueListenable: content,
                      builder: (BuildContext context, String value, Widget? child) {
                        return Text(value);
                      },
                    ),
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