import 'package:chat_module/resources/auth_methods.dart';
import 'package:chat_module/widgets/received_msg_widget.dart';
import 'package:chat_module/widgets/sent_msg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const routeName = '/chatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? name;
  final _formKey = GlobalKey<FlutterMentionsState>();

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text('Chat Module'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Text(''),
              ),
              InkWell(
                onTap: () async {
                  AuthMethods().signOut(context: context);
                },
                child: const ListTile(title: Text('Sign Out')),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: _firestore
                    .collection('messages')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: ((BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((document) {
                        return document['senderId'] != _auth.currentUser!.uid
                            ? ReceivedMsgWidget(
                                text: document['message'].toString(),
                                date: document['date']
                                    .toString()
                                    .substring(11, 16),
                                name: document['name'].toString(),
                              )
                            : SentMsgWidget(
                                text: document['message'].toString(),
                                date: document['date']
                                    .toString()
                                    .substring(11, 16),
                              );
                      }).toList(),
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
                        child: FlutterMentions(
                          key: _formKey,
                          suggestionPosition: SuggestionPosition.Top,
                          decoration: InputDecoration(
                            hintText: 'Text a message',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                          mentions: [
                            Mention(
                              trigger: '@',
                              style: const TextStyle(color: Colors.deepPurple),
                              data: data,
                              suggestionBuilder: (data) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Container(
                                    color: Colors.blueGrey,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(data['avatar']),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(data['name']),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
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
      ),
    );
  }

  Future sendMessage() async {
    String message = _formKey.currentState!.controller!.text;
    print(data);

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd-HH:mm:ss');
    String formattedDate = formatter.format(now);

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnaphot) {
      name = documentSnaphot['name'];
    });

    await _firestore.collection('messages').add({
      'senderId': _auth.currentUser!.uid,
      'message': message,
      'date': formattedDate,
      'name': name
    }).then((value) {
      _formKey.currentState!.controller!.text = '';
    });
  }

  Future getData() async {
    
    await FirebaseFirestore.instance.collection('users').get().then((snapshot) => snapshot.docs.forEach((element) {
      data.add(element.data());
      print(element.data());
     }));

    
  }
}
