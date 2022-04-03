import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/file_handler.dart';

class FileMsgTile extends StatefulWidget {
  final size;
  final Map<String, dynamic>? map;
  final String? displayName;
  final Directory? appStorage;

  FileMsgTile({this.size, this.map, this.displayName, this.appStorage});

  @override
  State<FileMsgTile> createState() => _FileMsgTileState();
}

class _FileMsgTileState extends State<FileMsgTile> {
  var filePath;

  String? checkFileExists(fileName) {
    final file = File("${widget.appStorage!.path}/$fileName");

    if (!file.existsSync()) {
      final file = File("${widget.appStorage!.path}/$fileName");
      downloadFile(widget.map!["link"], fileName, file);
      return null;
    } else {
      setState(() {
        filePath = file.path;
      });
      return file.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFileExists(widget.map!["message"]);
    return Container(
      width: widget.size.width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: widget.map!['sendBy'] == widget.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        width: widget.size.width * 0.5,
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.map!["sendBy"] == widget.displayName
                  ? Colors.blue
                  : Colors.grey,
              width: 5),
          borderRadius: BorderRadius.only(
            topLeft: widget.map!["sendBy"] == widget.displayName
                ? Radius.circular(20)
                : Radius.circular(0),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: widget.map!["sendBy"] == widget.displayName
                ? Radius.circular(0)
                : Radius.circular(20),
          ),
          color: widget.map!["sendBy"] == widget.displayName
              ? Colors.blue
              : Colors.grey,
        ),
        alignment: Alignment.center,
        child: widget.map!['link'] != ""
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      widget.map!["sendBy"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 2),
                  InkWell(
                    onTap: () => openFile(
                        url: widget.map!["link"],
                        fileName: widget.map!["message"]),
                    child: Container(
                      constraints:
                          BoxConstraints(minWidth: widget.size.width * 0.5),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.map!["message"],
                            style: const TextStyle(fontSize: 15),
                          ),
                          filePath == null
                              ? CircleAvatar(
                                  child: Icon(Icons.download),
                                  backgroundColor: Colors.white,
                                )
                              : Container()
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: widget.map!["sendBy"] == widget.displayName
                              ? Colors.blue[400]
                              : Colors.grey[400]),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "File",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('hh:mm a')
                              .format(widget.map!["time"].toDate())
                              .toLowerCase(),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: widget.size.width * 0.2,
                    ),
                  )
                ],
              )
            : Container(
                height: widget.size.width * 0.5,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: widget.map!["sendBy"] == widget.displayName
                    ? Colors.blue[400]
                    : Colors.grey[400],
              ),
      ),
    );
  }
}