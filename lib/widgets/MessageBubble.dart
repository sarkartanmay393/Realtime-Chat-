import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  final bool isMe;
  final String username;
  const MessageBubble(this.message, this.timestamp, this.isMe, this.username,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double length = message.length.toDouble();

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 12,
              ),
              width: 180, //MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: isMe ? Radius.circular(0) : Radius.circular(16),
                  bottomRight: !isMe ? Radius.circular(0) : Radius.circular(16),
                ),
                color: isMe ? Colors.grey[300] : Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isMe
                      ? Container()
                      : Text(
                          '- $username',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  const SizedBox(
                    height: 2,
                  ),
                  isMe
                      ? Text(
                          message,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                        )
                      : Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  isMe
                      ? Text(
                          "${timestamp.toDate().hour - 12}:${timestamp.toDate().minute}${(timestamp.toDate().hour > 12) ? 'PM' : 'AM'}",
                          style: const TextStyle(
                            fontSize: 8,
                            letterSpacing: 0.8,
                            color: Colors.black,
                          ),
                          //textAlign: TextAlign.end,
                        )
                      : Text(
                          "${timestamp.toDate().hour - 12}:${timestamp.toDate().minute}${(timestamp.toDate().hour > 12) ? 'PM' : 'AM'}",
                          style: const TextStyle(
                            fontSize: 8,
                            letterSpacing: 0.8,
                            color: Colors.white70,
                          ),
                          //textAlign: TextAlign.end,
                        ),
                ],
              ),
            ),
            // !isMe
            //     ? const CircleAvatar(
            //         maxRadius: 14,
            //         backgroundImage: NetworkImage(
            //             "https://yt3.ggpht.com/ytc/AKedOLQzHgQRN1lq-wqm_Zv91kgtZbSEK3JPJM7vU0obkTg=s600-c-k-c0x00ffffff-no-rj-rp-mo"),
            //       )
            //     : const CircleAvatar(radius: 0),
          ],
          //alignment: AlignmentDirectional.topEnd,
        ),
      ],
    );
  }
}
