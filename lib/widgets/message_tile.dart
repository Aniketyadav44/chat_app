import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

Widget MessageTile(size, map, displayName) {
  return Container(
    width: size.width,
    alignment: map!['sendBy'] == displayName
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //   topLeft: map!["sendBy"] == displayName
        //       ? const Radius.circular(20)
        //       : const Radius.circular(0),
        //   bottomRight: const Radius.circular(20),
        //   bottomLeft: const Radius.circular(20),
        //   topRight: map!["sendBy"] == displayName
        //       ? const Radius.circular(0)
        //       : const Radius.circular(20),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.7),
        //     spreadRadius: 5,
        //     blurRadius: 5,
        //     offset: Offset(10, 10), // changes position of shadow
        //   ),
        // ],
        borderRadius: BorderRadius.circular(25),
        gradient: const RadialGradient(
            center: Alignment.topRight,
            // near the top right
            radius: 6,
            colors: [
              Colors.purple,
              Colors.blue,
            ]),
        // color: map!["sendBy"] == displayName ? Colors.blue : Colors.grey,
      ),
      constraints: BoxConstraints(
        maxWidth: size.width * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              (map['sendBy']),
              style: TextStyle(
                color: Colors.amber[900],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SelectableText(
              map['message'],
              textWidthBasis: TextWidthBasis.parent,
              style: GoogleFonts.archivo(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              DateFormat('hh:mm a')
                  .format(map!["time"] != null
                      ? map!["time"].toDate()
                      : DateTime.now())
                  .toLowerCase(),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    ),
  );
}
