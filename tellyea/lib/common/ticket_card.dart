import 'package:tellyea/common/location_widget.dart';
import 'package:tellyea/common/FadePageRoute.dart';
import 'package:tellyea/pages/ticket_detail.dart';
import 'package:tellyea/model/YeetModel.dart';
import 'package:flutter/material.dart';
import 'package:tellyea/common/theme.dart';

import 'package:tellyea/main.dart';
import 'package:intl/intl.dart';

class YeetCardWidget extends StatefulWidget {
  final YeetModel yeetModel;

  YeetCardWidget({@required this.yeetModel});

  @override
  _YeetCardWidgetState createState() => _YeetCardWidgetState(yeetModel: yeetModel);
}

class _YeetCardWidgetState extends State<YeetCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  final YeetModel yeetModel;

  _YeetCardWidgetState({@required this.yeetModel});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MyAppState.onPage = false;
        return true;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Material(
          color: primaryColor,
          elevation: 20,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: InkWell(
            onTap: () {
              if (MyAppState.onPage == false) {
                Navigator.of(context).push(FadePageRoute(widget: TicketDetail(ticket: yeetModel)));
                MyAppState.onPage = true;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            YeetLeftWidget(
                              displayname: yeetModel.displayname,
                              username: "@" + yeetModel.username,
                              message: yeetModel.message,
                            ),
                            Spacer(),
                            Spacer(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                'https://karmafood.at/wp-content/uploads/2019/05/karma-food_new-brekkie-release.jpg',
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13.0),
                        SizedBox(height: 13.0),
                        SizedBox(height: 13.0),
                        SizedBox(height: 13.0),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(DateFormat('HH:mm').format(yeetModel.dateTime)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
