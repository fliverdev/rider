import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/message.dart';
import 'package:rider/widgets/send_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChatPage extends StatefulWidget {
  final SharedPreferences helper;
  MyChatPage({Key key, @required this.helper}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    String name = widget.helper.getString('userName');
    String identity = widget.helper.getString('uuid');

    if (messageController.text.length > 0) {
      await Firestore.instance.collection('messages').add({
        'text': messageController.text,
        'from': identity,
        'time': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.helper.getString('userName');
    String identity = widget.helper.getString('uuid');

    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                left: 20.0,
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
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('messages')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            me: identity == doc.data['from'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: 'Enter a message',
                        border: OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SendButton(
                    text: 'Send',
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
