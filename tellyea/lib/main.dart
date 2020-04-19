import 'package:tellyea/pages/PlaneTicketListPage.dart';
import 'package:tellyea/common/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static bool onPage = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: true,
      home: YeetListPage(),
    );
  }
}
