// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentHomework.dart';
import 'package:infixedu/utils/widget/TeacherHomeworkRow.dart';

class TeacherHomework extends StatefulWidget {
  @override
  _TeacherHomeworkState createState() => _TeacherHomeworkState();
}

class _TeacherHomeworkState extends State<TeacherHomework> {
  Future<HomeworkList> homeworks;

  String _token;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        Utils.getStringValue('id').then((value) {
          setState(() {
            homeworks = fetchHomework(int.parse(value));
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'Homeworks'),
        backgroundColor: Colors.white,
        body: FutureBuilder<HomeworkList>(
          future: homeworks,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              print(snapshot.data.homeworks.length);
              return ListView.builder(
                itemCount: snapshot.data.homeworks.length,
                itemBuilder: (context, index) {
                  return TeacherHomeworkRow(snapshot.data.homeworks[index]);
                },
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<HomeworkList> fetchHomework(int id) async {
    print(InfixApi.getHomeWorkListUrl(id));
    final response = await http.get(Uri.parse(InfixApi.getHomeWorkListUrl(id)),headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('HOMEWORK $jsonData');

      return HomeworkList.fromJson(jsonData['data']['homeworkLists']);
    } else {
      throw Exception('failed to load');
    }
  }
}
