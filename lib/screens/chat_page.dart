import 'package:chat_module/models/message.dart';
import 'package:chat_module/services/auth_methods.dart';
import 'package:chat_module/utils/letter_case_perm.dart';
import 'package:chat_module/widgets/received_msg_widget.dart';
import 'package:chat_module/widgets/sent_msg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:intl/intl.dart';
import '../utils/reactive.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const routeName = '/chatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FlutterMentionsState>();
  final Debounce debounce = Debounce(Duration(milliseconds: 400));
  final authMethods = AuthMethods();
  List<Map<String, dynamic>> data = [];
  final letterCasePerm = LetterCasePermutation();

  @override
  void initState() {
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
                  authMethods.signOut(context: context);
                },
                child: const ListTile(title: Text('Sign Out')),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: firestore
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
                      return document['senderId'] != auth.currentUser!.uid
                          ? ReceivedMsgWidget(
                              text: document['message'].toString(),
                              date:
                                  document['date'].toString().substring(11, 16),
                              name: document['name'].toString(),
                            )
                          : SentMsgWidget(
                              text: document['message'].toString(),
                              date:
                                  document['date'].toString().substring(11, 16),
                            );
                    }).toList(),
                  ),
                );
              }),
            ),
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
                          onSearchChanged: filterKey,
                          key: formKey,
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
                                    color: Colors.grey.shade200,
                                    child: Card(
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

  void filterKey(trigger, value) {
    data.clear();
    String text = formKey.currentState!.controller!.text;

    if (value.isNotEmpty)
      debounce(
        () {
          List<String> searchList = letterCasePerm.letterCasePermutation(
            text.substring(text.lastIndexOf('@') + 1),
          );

          getData(searchList);
          print('triggered');
        },
      );
  }

  Future sendMessage() async {
    String messageText = formKey.currentState!.controller!.text;
    String name = auth.currentUser!.displayName.toString();
    String senderId = auth.currentUser!.uid;
    String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final Message message = Message(
      messageText: messageText,
      senderId: senderId,
      date: date,
      name: name,
    );
    debugPrint(data.toString());

    await firestore.collection('messages').add(message.toJson()).then((value) {
      formKey.currentState!.controller!.text = '';
    });
  }

  Future getData(List filterData) async {
    //* filter firestore query by a list of strings

    filterData.forEach((element) async {
      await firestore
          .collection('users')
          .orderBy('name')
          .startAt([element])
          .endAt([element + '\uf8ff'])
          .get()
          .then((value) {
            value.docs.forEach((element) {
              data.add({
                'display': element['name'],
                'id': element['senderId'],
                'avatar': element['avatar'],
                'name': element['name']
              });
              print(element.data());
            });
          });
      setState(() {});
    });
  }
}
