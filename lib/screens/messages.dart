import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:bluechat/provider/mainprovider.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:bluechat/models/messagesModel.dart';
import 'package:bluechat/functions/database.dart';
import 'package:intl/intl.dart';


class ChatScreen extends StatefulWidget {
  final String userName;
  final int photoID;
  final String endpointId;

  ChatScreen({required this.userName,required this.photoID,required this.endpointId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();


  void _sendMessage(BuildContext ctx) async {
    final providerData = Provider.of<MainProvider>(ctx, listen: false);
    String message = _messageController.text;
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);

    if (message.isNotEmpty) {
      // Encode the message as bytes and send it as a payload
      Uint8List payload = Uint8List.fromList(utf8.encode(message));

      //providerData.addNewMessages(message);
      final Messages msgdata = Messages(sender: providerData.username,receiver: widget.endpointId,message: message,timestamp: formattedTime.toString());
      await providerData.addMessage(msgdata).then((value) async{
        providerData.notifyListeners();
        await Nearby().sendBytesPayload(widget.endpointId, payload).then((value) {

        });
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<MainProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/avatars/${widget.photoID}.png'),
            ),
            SizedBox(width: 16),
            Text(
              '${widget.userName}',
              style: TextStyle(fontSize: 20,color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                child:
                ListView.builder(
                  itemCount: context.watch<MainProvider>().messagesList.length,
                  itemBuilder: (context, index) {
                    return ChatMessage(
                      text: context.watch<MainProvider>().messagesList[index].message,
                      isMe: context.watch<MainProvider>().messagesList[index].sender == providerData.username ? true : false,
                      time: context.watch<MainProvider>().messagesList[index].timestamp,
                    );
                  },
                ),
              ),
            )
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: Colors.grey[600]!),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (value) {

                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isMe,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft:
                isMe ? const Radius.circular(20) : const Radius.circular(0),
                bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(20),
              ),
              color: isMe ? Colors.blue : Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),)
        ],
      ),
    );
  }
}
