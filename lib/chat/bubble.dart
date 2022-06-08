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
    MainAxisAlignment alignment = MainAxisAlignment.spaceBetween;
    EdgeInsetsGeometry margin;
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(10, 6, 10, 6);
    Color bubbleColor;
    Color textColor;
    TextAlign textAlign;

    if (widget.isMine) {
      // sent by current user
      margin = const EdgeInsets.only(left: 15);
      bubbleColor = const Color(0xFF1982FC);
      textColor = CupertinoColors.white;
      textAlign = TextAlign.right;
    } else {
      // sent by other user
      margin = const EdgeInsets.only(right: 15);
      bubbleColor = CupertinoColors.systemGrey5;
      textColor = CupertinoColors.black;
      textAlign = TextAlign.left;
    }

    Text time = Text(
        widget.msg.time,
        style:
            const TextStyle(
                color: CupertinoColors.secondaryLabel,
                fontSize: 12,
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
