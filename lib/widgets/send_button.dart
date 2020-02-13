import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: MyColors.primary,
      onPressed: callback,
      child: Text(text),
    );
  }
}
