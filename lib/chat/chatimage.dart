import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'chathelper.dart';
import 'message.dart';

class ChatImage extends StatefulWidget {
  const ChatImage({Key? key, required this.helper, required this.currentUid}) : super(key: key);

  final ChatHelper helper;
  final String currentUid;

  @override
  State<ChatImage> createState() => _ChatImageState();
}

class _ChatImageState extends State<ChatImage> {
  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.only(right: 10),
        child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              showCupertinoModalPopup<void>(
                  context: context,
                  builder: (context) => buildActionSheet(context)
              );
            },
            child: const Icon(CupertinoIcons.camera_fill, size: 26, color: CupertinoColors.systemGrey)
        )
    );
  }

  Future<void> imagePicker (BuildContext context) async {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return const Center(child: CupertinoActivityIndicator(color: CupertinoColors.white));
        }
    ).then((val) => Navigator.pop(context));

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadFile(image);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> cameraPicker () async {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return const Center(child: CupertinoActivityIndicator(color: CupertinoColors.white));
        }
    ).then((val) => Navigator.pop(context));

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      uploadFile(image);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> uploadFile(XFile image) async {
    final storageRef = FirebaseStorage.instance.ref().child('chat').child(widget.helper.listing.docId).child(widget.helper.buyerId);

    String uploadFileName = 'chat_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference reference = storageRef.child(uploadFileName);

    UploadTask uploadTask = reference.putFile(File(image.path));
    uploadTask.whenComplete(() {
      reference.getDownloadURL().then((url) {
        Message msg = Message(
            sentBy: widget.currentUid,
            message: '',
            time: '',
            imageUrl: url
        );
        widget.helper.manageChat('image');
        FirebaseFirestore.instance
            .collection('search_listings')
            .doc(widget.helper.listing.docId)
            .collection('chats')
            .doc(widget.helper.buyerId)
            .collection('messages')
            .add(msg.imageToFirestore());
      });
    });
  }

  Widget buildActionSheet(BuildContext context) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
          onPressed: () async {
            imagePicker(context);

          },
          child: Text('Gallery', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
      ),
      CupertinoActionSheetAction(
          onPressed: () {
            cameraPicker();
          },
          child: Text('Take a photo', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
      )
    ],
    cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
        child: Text('Cancel', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
    ),
  );
}

