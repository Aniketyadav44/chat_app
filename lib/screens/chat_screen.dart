import 'package:chat_new/widgets/file_msg_tile.dart';
import 'package:chat_new/widgets/image_msg_tile.dart';
import 'package:chat_new/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

  Directory? appStorage;

  Future getImage() async {
    //to get the image from galary
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        pickedFile = File(xFile.path);
        pickedFileName = xFile.name.toString();
        uploadFile("image");
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

  Future uploadFile(type) async {
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
        "type": type == "image" ? "image" : "file",
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child(type == "image" ? "images" : "files")
          .child(pickedFileName!);

      var uploadTask = await ref.putFile(pickedFile!);

      String fileUrl = await uploadTask.ref.getDownloadURL();

      await sentData.update({"link": fileUrl});
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

  Future getStoragePath() async {
    final s = await getExternalStorageDirectory();
    print(s!.path);
    setState(() {
      appStorage = s;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoragePath();
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
      body: appStorage == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data != null) {
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> map =
                                        // messageData =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;

                                    return messages(
                                        size, map, context, appStorage);
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
                    alignment: Alignment.bottomCenter,
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

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,
      Directory? appStorage) {
    //help us to show the text and the image in perfect alignment
    return map['type'] == "text" //checks if our msg is text or image
        ? MessageTile(
            size,
            map,
            _auth.currentUser!.displayName,
          )
        : map["type"] == "image"
            ? ImageMsgTile(
                map: map,
                displayName: _auth.currentUser!.displayName,
                appStorage: appStorage)
            : FileMsgTile(
                size: size,
                map: map,
                displayName: _auth.currentUser!.displayName,
                appStorage: appStorage,
              );
  }
}
