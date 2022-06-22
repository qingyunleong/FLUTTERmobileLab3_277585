import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab2/model/config.dart';
import 'package:lab2/model/courses.dart';
import 'package:lab2/model/user.dart';

import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Subjects extends StatefulWidget {
  final User user;
  const Subjects({Key? key, required this.user}) : super(key: key);

  @override
  _Subjects createState() => _Subjects();
}

class _Subjects extends State<Subjects> {
  List<Courses> coursesList = <Courses>[];

  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  var numofpage, curpage = 1;
  var color;

  File? _image;
  var pathAsset = "assets/images/NotFound.png";

  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadCourses(1, search);
    });
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
      body: coursesList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Courses Available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 0.45),
                      children: List.generate(coursesList.length, (index) {
                        return InkWell(
                            splashColor: Colors.red,
                            onTap: () => {_loadCourseDetails(index)},
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.grey, width: 0.5),
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 10, 5),
                                                  child: CachedNetworkImage(
                                                    imageUrl: Config.server +
                                                        "/mobile_lab3/assets/courses/" +
                                                        coursesList[index]
                                                            .subjectId
                                                            .toString() +
                                                        '.jpg',
                                                    fit: BoxFit.cover,
                                                    width: resWidth,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                new CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                      Icons.image_not_supported,
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
                                                      decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: _image == null
                                                          ? AssetImage(
                                                              pathAsset)
                                                          : FileImage(_image!)
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
                                                  coursesList[index]
                                                      .subjectName
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              const SizedBox(height: 10),
                                              Text(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                coursesList[index]
                                                    .subjectDescription
                                                    .toString(),
                                                textAlign: TextAlign.justify,
                                              ),
                                              const SizedBox(height: 10),
                                              Table(
                                                columnWidths: const {
                                                  0: FractionColumnWidth(0.1),
                                                  1: FractionColumnWidth(0.8)
                                                },
                                                defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                children: [
                                                  TableRow(children: [
                                                    Icon(Icons.star,
                                                        color: Colors.yellow),
                                                    Text(coursesList[index]
                                                        .subjectRating
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
                          onPressed: () => {_loadCourses(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        backgroundColor: Colors.black,
        onPressed: () {
          _loadSearchDialog();
        },
      ),
    );
  }

  void _loadCourses(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Loading...', max: 100);

    http.post(Uri.parse(Config.server + "/mobile_lab3/php/load_courses.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(const Duration(seconds: 3), onTimeout: () {
      return http.Response('Error', 408);
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response('Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          coursesList = <Courses>[];
          extractdata['subjects'].forEach((v) {
            coursesList.add(Courses.fromJson(v));
          });
          titlecenter = coursesList.length.toString() + " Subject Available";
        } else {
          titlecenter = "No Subjects Available";
          coursesList.clear();
        }
        setState(() {});
      } else {
        setState(() {
          if (coursesList.isEmpty) {
            titlecenter = "No Subjects Available";
            coursesList.clear();
            setState(() {});
          }
        });
      }
    });
    pd.close();
  }

  _loadCourseDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.884),
            insetPadding: EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Courses Details",
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
                      "/mobile_lab3/assets/courses/" +
                      coursesList[index].subjectId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth / 1.8,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 30),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(coursesList[index].subjectName.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("About This Course",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    coursesList[index].subjectDescription.toString(),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.1),
                      1: FractionColumnWidth(0.8)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Text(coursesList[index].subjectRating.toString()),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "Price: RM " +
                          double.parse(
                                  coursesList[index].subjectPrice.toString())
                              .toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                      "Course Session: " +
                          coursesList[index].subjectSessions.toString() +
                          " classes",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                    child:
                        Divider(color: Colors.grey, height: 1, thickness: 0.8),
                  ),
                  const Text("Instructor : ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          child: Row(
                        children: [
                          _image == null
                              ? Flexible(
                                  flex: 4,
                                  child: SizedBox(
                                      child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: CachedNetworkImage(
                                      imageUrl: Config.server +
                                          "/mobile_lab3/assets/tutors/" +
                                          coursesList[index]
                                              .tutorId
                                              .toString() +
                                          '.jpg',
                                      fit: BoxFit.cover,
                                      width: resWidth / 3.5,
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 60,
                                        backgroundImage: imageProvider,
                                      ),
                                    ),
                                  )),
                                )
                              : SizedBox(
                                  height: screenHeight * 0.25,
                                  child: SizedBox(
                                    child: GestureDetector(
                                      child: Container(
                                          decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: _image == null
                                              ? AssetImage(pathAsset)
                                              : FileImage(_image!)
                                                  as ImageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                    ),
                                  )),
                          Flexible(
                              flex: 6,
                              child: Column(
                                children: [
                                  Text(coursesList[index].tutorName.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                        ],
                      ))),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.2),
                            1: FractionColumnWidth(0.8)
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(children: [
                              const Icon(Icons.email),
                              Text(coursesList[index].tutorEmail.toString()),
                            ]),
                            TableRow(children: [
                              const Icon(Icons.phone),
                              Text(coursesList[index].tutorPhone.toString()),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ]),
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

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadCourses(1, search);
                    },
                    child: const Text("Search"),
                  ),
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
            },
          );
        });
  }
}
