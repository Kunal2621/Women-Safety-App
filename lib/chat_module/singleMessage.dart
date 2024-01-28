import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final bool? isMe;
  final String? image;
  final String? type;
  final String? friendName;
  final String? myName;
  final Timestamp? date;
  final bool showGap;

  const SingleMessage({
    Key? key,
    this.message,
    this.isMe,
    this.image,
    this.type,
    this.friendName,
    this.myName,
    this.date,
    this.showGap = false, // Add a parameter to control gap visibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime d = DateTime.parse(date!.toDate().toString());
    String cdate = "${d.hour}" + ":" + "${d.minute}";

    return type=="text"?
    
     Column(
      crossAxisAlignment:
          isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showGap) SizedBox(height: 8), // Add a gap if showGap is true
        Container(
          constraints: BoxConstraints(
            maxWidth: size.width / 2,
          ),
          alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: isMe! ? Colors.blue : Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: isMe! ? Radius.circular(15) : Radius.zero,
                topRight: isMe! ? Radius.zero : Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxWidth: size.width / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isMe! ? myName! : friendName!,
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
                Text(
                  message!,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "$cdate",
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    ):
 type=='img'?
  Column(
  crossAxisAlignment: isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  children: [
    if (showGap) SizedBox(height: 8), // Add a gap if showGap is true
    SingleChildScrollView( // Wrap the content in a SingleChildScrollView
      scrollDirection: Axis.horizontal, // Scroll horizontally if necessary
      child: Container(
       // height: MediaQuery.sizeOf(context).height,
        height: size.height /2,
        width: size.width,
        alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
        //   height: MediaQuery.sizeOf(context).height,
          height: size.height /2,
          width: size.width,
          decoration: BoxDecoration(
            color: isMe! ? Colors.blue : Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: isMe! ? Radius.circular(15) : Radius.zero,
              topRight: isMe! ? Radius.zero : Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isMe! ? myName! : friendName!,
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
              CachedNetworkImage(
                imageUrl: message ?? "", // Provide a default value for message
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                "$cdate",
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
):

 

    Column(
      crossAxisAlignment:
          isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showGap) SizedBox(height: 8), // Add a gap if showGap is true
        Container(
          constraints: BoxConstraints(
            maxWidth: size.width / 2,
          ),
          alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: isMe! ? Colors.blue : Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: isMe! ? Radius.circular(15) : Radius.zero,
                topRight: isMe! ? Radius.zero : Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxWidth: size.width / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isMe! ? myName! : friendName!,
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () async{
                    await launchUrl(Uri.parse("$message"));
                  },
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16, color: Colors.white),
                  ),
                ),
                Text(
                  "$cdate",
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
 
  }
}
