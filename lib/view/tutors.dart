import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab2/model/config.dart';
import 'package:lab2/model/tutors.dart';
import 'package:lab2/model/user.dart';

import 'package:http/http.dart' as http;

class Tutor extends StatefulWidget {
  final User user;
  const Tutor({Key? key, required this.user}) : super(key: key);

  @override
  _Tutor createState() => _Tutor();
}

class _Tutor extends State<Tutor> {
  List<Tutors> tutorsList = <Tutors>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  var numofpage, curpage = 1;
  var color;

  File? _image;
  var pathAsset = "assets/images/NotFound.png";

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      resWidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      resWidth = screenWidth / 1.1;
    }

    return Scaffold(
      body: tutorsList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Tutors Available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.45),
                      children: List.generate(tutorsList.length, (index) {
                        return InkWell(
                            splashColor: Colors.grey,
                            onTap: () => {_loadTutorDetails(index)},
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          child: Row(
                                        children: [
                                          _image == null
                                              ? Flexible(
                                                  flex: 4,
                                                  child: SizedBox(
                                                      child: GestureDetector(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 5, 10, 5),
                                                      child: CachedNetworkImage(
                                                        imageUrl: Config
                                                                .server +
                                                            "/mobile_lab3/assets/tutors/" +
                                                            tutorsList[index]
                                                                .tutorId
                                                                .toString() +
                                                            '.jpg',
                                                        fit: BoxFit.cover,
                                                        width: resWidth,
                                                        placeholder: (context,
                                                                url) =>
                                                            const LinearProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          size: 128,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                )
                                              : SizedBox(
                                                  height: screenHeight * 0.25,
                                                  child: SizedBox(
                                                    child: GestureDetector(
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                        image: DecorationImage(
                                                          image: _image == null
                                                              ? AssetImage(
                                                                  pathAsset)
                                                              : FileImage(
                                                                      _image!)
                                                                  as ImageProvider,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                    ),
                                                  )),
                                          Flexible(
                                              flex: 6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      tutorsList[index]
                                                          .tutorName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 2, 0, 8),
                                                    child: Divider(
                                                      color: Colors.blueGrey,
                                                      height: 1,
                                                      thickness: 2.0,
                                                    ),
                                                  ),
                                                  Table(
                                                    columnWidths: const {
                                                      0: FractionColumnWidth(
                                                          0.2),
                                                      1: FractionColumnWidth(
                                                          0.8)
                                                    },
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    children: [
                                                      TableRow(children: [
                                                        const Icon(Icons.email),
                                                        Text(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            tutorsList[index]
                                                                .tutorEmail
                                                                .toString()),
                                                      ]),
                                                      TableRow(children: [
                                                        const Icon(Icons.phone),
                                                        Text(tutorsList[index]
                                                            .tutorPhone
                                                            .toString()),
                                                      ]),
                                                    ],
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )))
                                ])));
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.grey;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadTutors(index + 1)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;

    http.post(Uri.parse(Config.server + "/mobile_lab3/php/load_tutors.php"),
        body: {
          'pageno': pageno.toString(),
        }).timeout(const Duration(seconds: 1), onTimeout: () {
      return http.Response('Error', 408);
    }).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['tutors'] != null) {
          tutorsList = <Tutors>[];
          extractdata['tutors'].forEach((v) {
            tutorsList.add(Tutors.fromJson(v));
          });
        } else {
          titlecenter = "No Tutors Available";
        }
        setState(() {});
      } else {
        setState(() {
          if (tutorsList.isEmpty) {
            titlecenter = "No Tutors Available";
          }
        });
      }
    });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.884),
            insetPadding: EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Tutor Details",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                  child: Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 2.0,
                  ),
                ),
                const SizedBox(height: 20),
                CachedNetworkImage(
                  imageUrl: Config.server +
                      "/mobile_lab3/assets/tutors/" +
                      tutorsList[index].tutorId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth / 1.8,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 30),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tutorsList[index].tutorName.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Tutor Description",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    tutorsList[index].tutorDescription.toString(),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.15),
                      1: FractionColumnWidth(0.8)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        const Icon(Icons.email),
                        Text(tutorsList[index].tutorEmail.toString()),
                      ]),
                      TableRow(children: [
                        const Icon(Icons.phone),
                        Text(tutorsList[index].tutorPhone.toString()),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 20),
                ]),
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
