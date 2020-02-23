import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';

class Message extends StatelessWidget {
  final bool isMe;
  final String senderId;
  final String senderName;
  final String messageText;
  final LatLng location;
  final String timestampIso;
  final DateTime timestamp;

  const Message({
    Key key,
    this.isMe,
    this.senderId,
    this.senderName,
    this.messageText,
    this.location,
    this.timestampIso,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Material(
            color: isMe ? MyColors.primary : invertInvertColorsMild(context),
            borderRadius: BorderRadius.circular(8.0),
            elevation: 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$senderName says:',
                    style: isMe
                        ? MessageSenderStyles.black
                        : isThemeCurrentlyDark(context)
                            ? MessageSenderStyles.white
                            : MessageSenderStyles.black,
                  ),
                  Text(
                    '$messageText',
                    style: isMe
                        ? MessageTextStyles.black
                        : isThemeCurrentlyDark(context)
                            ? MessageTextStyles.white
                            : MessageTextStyles.black,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
