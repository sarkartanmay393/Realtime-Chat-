import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Converse'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/gRJbKKsH1bZKzawi3gwH/messages/')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> ss) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 450,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(6.0),
              child: ss.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemBuilder: (ctx, i) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(ss.data!.docs[i]['text']),
                              leading: const Icon(Icons.man),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                      itemCount: ss.data!.docs.length,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(hintText: "Type a message"),
                controller: _messageController,
                onSubmitted: (_) {
                  FirebaseFirestore.instance
                      .collection('chats/gRJbKKsH1bZKzawi3gwH/messages')
                      .add({'text': _messageController.text});
                  _messageController.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
