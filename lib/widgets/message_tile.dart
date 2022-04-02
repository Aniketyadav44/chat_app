import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget MessageTile(size, map, displayName) {
  return Container(
    width: size.width,
    alignment: map!['sendBy'] == displayName
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
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
          color: map!["sendBy"] == displayName ? Colors.blue : Colors.grey),
      constraints: BoxConstraints(
        maxWidth: size.width * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            map!["sendBy"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          SelectableText(
            map!['message'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            toolbarOptions: ToolbarOptions(
              copy: true,
              selectAll: true,
            ),
          ),
          Container(
            child: Text(
              DateFormat('hh:mm a')
                  .format(map!["time"] != null
                      ? map!["time"].toDate()
                      : DateTime.now())
                  .toLowerCase(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            constraints: BoxConstraints(
              minWidth: size.width * 0.2,
            ),
          )
        ],
      ),
    ),
  );
}
