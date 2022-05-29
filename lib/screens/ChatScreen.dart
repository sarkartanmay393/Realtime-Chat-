import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_converse/widgets/MessageBubble.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = 'ChatScreen';

  ChatScreen({Key? key}) : super(key: key);

  final _messageController = TextEditingController();

  final String uid = FirebaseAuth.instance.currentUser!.uid;
  // final userInfo =
  //     FirebaseFirestore.instance.collection('users').doc(uid).get();

  void _sendMessage(BuildContext ctx) async {
    String ownUsername = '';
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      ownUsername = value.data()!['username'];
    });
    _messageController.text.isEmpty
        ? null
        : FirebaseFirestore.instance
            .collection('chats/gRJbKKsH1bZKzawi3gwH/messages')
            .add({
            'text': _messageController.text.trim(),
            'time': Timestamp.now(),
            'userId': uid,
            'username': ownUsername,
          });
    _messageController.clear();
    FocusScope.of(ctx).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Converse'),
        actions: [
          DropdownButton(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                value: 'profile',
                child: TextButton.icon(
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Profile'),
                  onPressed: () {},
                ),
              ),
              DropdownMenuItem(
                value: 'logout',
                child: TextButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            ],
            onChanged: (_) {
              return;
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/gRJbKKsH1bZKzawi3gwH/messages/')
            .orderBy(
              'time',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> ss) => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ss.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      reverse: true,
                      itemBuilder: (ctx, i) {
                        final bool isMe =
                            FirebaseAuth.instance.currentUser!.uid ==
                                ss.data!.docs[i]['userId'];
                        final message = ss.data!.docs[i]['text'];
                        final time = ss.data!.docs[i]['time'] as Timestamp;
                        final username = ss.data!.docs[i]['username'];
                        key:
                        ValueKey(ss.data!.docs[i].id);
                        return MessageBubble(message, time, isMe, username);
                      },
                      itemCount: ss.data!.docs.length,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "Type a message",
                          labelText: 'Send messages'),
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendMessage(context),
                    icon: const Icon(
                      Icons.send,
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
