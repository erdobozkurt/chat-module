import 'package:chat_module/widgets/received_msg_widget.dart';
import 'package:chat_module/widgets/sent_msg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const routeName = '/chatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Chat Module'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Text(''),
            ),
            InkWell(
              onTap: signOutFirebase,
              child: const ListTile(title: Text('Sign Out')),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('date')
                  .snapshots(),
              builder: ((BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: snapshot.data!.docs
                        .map((document) {
                          return document['senderId'] != _auth.currentUser!.uid
                              ? ReceivedMsgWidget(
                                  text: document['message'].toString(),
                                  date: document['date']
                                      .toString()
                                      .substring(11, 16),
                                )
                              : SentMsgWidget(
                                  text: document['message'].toString(),
                                  date: document['date']
                                      .toString()
                                      .substring(11, 16),
                                );
                        })
                        .toList()
                        .reversed
                        .toList(),
                  ),
                );
              })),
          Container(
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Text a message',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send),
                      color: Colors.cyan.shade900,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future sendMessage() async {
    String message = controller.text;
    controller.clear();

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd-HH:mm:ss');
    String formattedDate = formatter.format(now);

    await FirebaseFirestore.instance.collection('messages').add({
      'senderId': _auth.currentUser!.uid,
      'message': message,
      'date': formattedDate
    });
  }

  Future signOutFirebase() async{
    await FirebaseAuth.instance.signOut().then((value) {
       Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
    
  }
}
