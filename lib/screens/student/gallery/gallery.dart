import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infixedu/screens/student/gallery/photos.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';

class Gallery extends StatefulWidget {
  String id;

  Gallery({this.id});
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  loadData() async {
    var response = await http.get(Uri.parse(InfixApi.getAlbum));
    Map<String, dynamic> decodedJson = json.decode(response.body);
    List<dynamic> responseData = decodedJson['data'];
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Gallery'),
      body: Container(
          child: FutureBuilder(
              future: loadData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (2 / 0.9),
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            String idd = snapshot.data[index]['id'];
                            Navigator.push(
                    context,
                    ScaleRoute(
                        page: Photos(id: idd,)));
                          },
                          child: Card(
                            elevation: 4,
                            color: Colors.white,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      "https://admin.scoolspro.com/albums/" +
                                          snapshot.data[index]['cover_image'],
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width,
                                      //fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child:
                                          Text(snapshot.data[index]['name'])),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: Text(
                                    'Total files ' +
                                        snapshot.data[index]['photos'].length
                                            .toString(),
                                    maxLines: 1,
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color(0xff3575B6),
                  ));
                }
              })),
    );
  }
}