import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget ImageMsgTile(size, map, displayName, context) {
  return Container(
    width: size.width,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    alignment: map!['sendBy'] == displayName
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ShowImage(
            imageUrl: map!['link'],
          ),
        ),
      ),
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
                    constraints: BoxConstraints(minHeight: size.width * 0.5),
                    child: Image.network(
                      map!["link"],
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(map!["time"].toDate())
                          .toLowerCase(),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
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
    ),
  );
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
