import 'package:flutter/cupertino.dart';

import 'message.dart';

class Bubble extends StatefulWidget {
  const Bubble({Key? key, required this.msg, required this.isMine})
      : super(key: key);

  final Message msg;
  final bool isMine;

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    MainAxisAlignment alignment;  // which side to align bubble to
    EdgeInsetsGeometry margin;  // space between bubble and timestamp
    double marginValue = 8;
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(10, 6, 10, 6);  // inner text padding from bubble walls
    Color bubbleColor;
    Color textColor;
    TextAlign textAlign;

    if (widget.isMine) {
      // sent by current user
      alignment = MainAxisAlignment.end;
      margin = EdgeInsets.only(left: marginValue);
      bubbleColor = const Color(0xFF1982FC);
      textColor = CupertinoColors.white;
      textAlign = TextAlign.right;
    } else {
      // sent by other user
      alignment = MainAxisAlignment.start;
      margin = EdgeInsets.only(right: marginValue);
      bubbleColor = CupertinoColors.systemGrey5;
      textColor = CupertinoColors.black;
      textAlign = TextAlign.left;
    }

    Container time = Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Text(
          widget.msg.time,
          style:
          const TextStyle(
            color: CupertinoColors.secondaryLabel,
            fontSize: 12,
          )
      )
    );

    Text message = Text(widget.msg.message,
        textAlign: textAlign, style: TextStyle(color: textColor));

    Flexible bubble = Flexible(
        child: Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: bubbleColor),
            child: message));

    List<Widget> children;
    if (widget.isMine) {
      children = [time, bubble];
    } else {
      children = [bubble, time];
    }

    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }
}
