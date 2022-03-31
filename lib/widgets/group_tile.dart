import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class GroupTile extends StatelessWidget {
  Map<String, dynamic>? groupData;

  GroupTile({this.groupData});

  String getDate(Timestamp time) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(time as int);
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(groupData!["data"]["icon"]),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: width * 0.55,
                        child: Text(
                          groupData!["data"]["name"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        (groupData!["data"]["recent_message"] != null
                            ? DateFormat('hh:mm a')
                                .format((groupData!["data"]["recent_message"]
                                        ["time"])
                                    .toDate())
                                .toLowerCase()
                            : ""),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    groupData!["data"]["recent_message"] != null
                        ? "${groupData!["data"]["recent_message"]["sentBy"]}: ${groupData!["data"]["recent_message"]["message"]}"
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
