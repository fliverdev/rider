import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChatPage extends StatefulWidget {
  final SharedPreferences helper;
  MyChatPage({Key key, @required this.helper}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<void> callback() async {
    String name = widget.helper.getString('userName');
    String identity = widget.helper.getString('uuid');

    if (_messageController.text.length > 0) {
      await Firestore.instance.collection('messages').add({
        'senderId': identity,
        'senderName': name,
        'messageText': _messageController.text,
        'timestamp': DateTime.now().toIso8601String().toString(),
      });

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String identity = widget.helper.getString('uuid');

    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                left: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    tooltip: 'Go back',
                    iconSize: 20.0,
                    color: invertColorsStrong(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Chat',
                    style: isThemeCurrentlyDark(context)
                        ? TitleStyles.white
                        : TitleStyles.black,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: invertColorsTheme(context),
                        ),
                      );

                    List<DocumentSnapshot> docs = snapshot.data.documents;

                    List<Widget> messages = docs
                        .map((doc) => Message(
                              isMe: identity == doc.data['senderId'],
                              senderId: doc.data['senderId'],
                              senderName: doc.data['senderName'],
                              messageText: doc.data['messageText'],
                              timestamp: doc.data['timestamp'],
                            ))
                        .toList();

                    return ListView(
                      controller: _scrollController,
                      children: <Widget>[
                        ...messages,
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (value) => callback(),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: invertColorsStrong(context),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: invertColorsTheme(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  FloatingActionButton(
                    heroTag: 'chat',
                    foregroundColor: invertInvertColorsTheme(context),
                    backgroundColor: invertColorsTheme(context),
                    child: Icon(Icons.send),
                    elevation: 5.0,
                    tooltip: 'Send',
                    onPressed: callback,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
