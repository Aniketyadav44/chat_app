import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ChatScreen extends StatefulWidget {
  final groupData;
  String? groupId;

  ChatScreen({this.groupData, this.groupId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _message = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? pickedFile;

  String? pickedFileName;

  Future getImage() async {
    //to get the image from galary
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        pickedFile = File(xFile.path);
        pickedFileName = xFile.name.toString();
        uploadImage();
      }
    });
  }

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File a = File(result.files.single.path.toString());
      pickedFile = a;
      pickedFileName = result.names[0].toString();
      uploadFile("file");
    }
  }

  Future uploadImage() async {
    try {
      var sentData = await _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add({
        "link": "",
        "message": pickedFileName,
        "sendBy": _auth.currentUser!.displayName,
        "time": FieldValue.serverTimestamp(),
        "type": "image",
      });
      var ref =
          FirebaseStorage.instance.ref().child("images").child(pickedFileName!);

      var uploadTask = await ref.putFile(pickedFile!);

      String fileUrl = await uploadTask.ref.getDownloadURL();

      await sentData.update({"link": fileUrl});
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future uploadFile(String type) async {
    try {
      Fluttertoast.showToast(msg: "Sending...");
      var ref = FirebaseStorage.instance
          .ref()
          .child(type == "image" ? "images" : "files")
          .child(pickedFileName!);

      var uploadTask = await ref.putFile(pickedFile!);

      String fileUrl = await uploadTask.ref.getDownloadURL();

      _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add({
        "link": fileUrl,
        "message": pickedFileName,
        "sendBy": _auth.currentUser!.displayName,
        "time": FieldValue.serverTimestamp(),
        "type": type,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // Future uploadImage() async {
  void onSendMessage() async {
    //to send the text to server
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": _message.text,
        "sendBy": _auth.currentUser!.displayName,
        "type": "text", //_auth.currentUser!.displayName,
        "time": FieldValue.serverTimestamp()
      };

      await _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add(message);

      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_back),
                  )),
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    NetworkImage(widget.groupData!["data"]["icon"]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.52,
                          child: Text(
                            widget.groupData!["data"]["name"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Container(
                    width: width * 0.5,
                    child: Text("Group Info"),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {}
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _firestore
                        .collection("groups")
                        .doc(widget.groupData!["id"])
                        .collection("chats") !=
                    null
                ? Container(
                    height: size.height / 1.27,
                    width: size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("groups")
                          .doc(widget.groupData!["id"])
                          .collection("chats")
                          .orderBy("time", descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> map =
                                  // messageData =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                              return messages(size, map, context);
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                : Center(child: Text("No Chats Yet.")),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(children: [
                  Container(
                    height: size.height / 12,
                    width: size.width / 1.3,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _message,
                      autocorrect: true,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          width: width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => getFile(),
                                icon: Icon(Icons.attach_file),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo),
                                onPressed: () => getImage(),
                              ),
                            ],
                          ),
                        ),
                        hintText: "Type A Message",
                        border: OutlineInputBorder(
                          gapPadding: 50,
                          borderRadius: BorderRadius.circular(
                            (10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onSendMessage,
                    icon: Icon(Icons.send),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    //help us to show the text and the image in perfect alignment
    return map['type'] == "text" //checks if our msg is text or image
        ? Container(
            width: size.width,
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: Colors.blue),
              constraints: BoxConstraints(
                maxWidth: size.width * 0.7,
              ),
              child: SelectableText(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  selectAll: true,
                ),
              ),
            ),
          )
        : map["type"] == "image"
            ? Container(
                height: size.width * 0.5,
                width: size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                alignment: map['sendby'] == _auth.currentUser!.displayName
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ShowImage(
                        imageUrl: map['link'],
                      ),
                    ),
                  ),
                  child: Container(
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.grey[400]),
                    alignment: Alignment.center,
                    child: map['link'] != ""
                        ? Image.network(
                            map["link"],
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              )
            : Container(
                width: size.width,
                alignment: map['sendby'] == _auth.currentUser!.displayName
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Text(map['message']),
              );
  }
}

class ShowImage extends StatelessWidget {
  //to show the image fullscreen
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network("$imageUrl"),
      ),
    );
  }
}
