import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileMsgTile extends StatelessWidget {
  final size;
  final Map<String, dynamic>? map;
  final String? displayName;

  FileMsgTile({this.size, this.map, this.displayName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: map!['sendBy'] == displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        width: size.width * 0.5,
        decoration: BoxDecoration(
          border: Border.all(
              color: map!["sendBy"] == displayName ? Colors.blue : Colors.grey,
              width: 5),
          borderRadius: BorderRadius.only(
            topLeft: map!["sendBy"] == displayName
                ? Radius.circular(20)
                : Radius.circular(0),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: map!["sendBy"] == displayName
                ? Radius.circular(0)
                : Radius.circular(20),
          ),
          color: map!["sendBy"] == displayName ? Colors.blue : Colors.grey,
        ),
        alignment: Alignment.center,
        child: map!['link'] != ""
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      map!["sendBy"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    constraints: BoxConstraints(minWidth: size.width * 0.5),
                    padding: const EdgeInsets.only(left: 10),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      map!["message"],
                      style: const TextStyle(fontSize: 15),
                    ),
                    decoration: BoxDecoration(
                        color: map!["sendBy"] == displayName
                            ? Colors.blue[400]
                            : Colors.grey[400]),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "File",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('hh:mm a')
                              .format(map!["time"].toDate())
                              .toLowerCase(),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: size.width * 0.2,
                    ),
                  )
                ],
              )
            : Container(
                height: size.width * 0.5,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: map!["sendBy"] == displayName
                    ? Colors.blue[400]
                    : Colors.grey[400],
              ),
      ),
    );
  }
}
