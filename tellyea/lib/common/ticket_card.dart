import 'package:tellyea/backend/SmallFunctions.dart';
import 'package:tellyea/common/FadePageRoute.dart';
import 'package:tellyea/pages/ticket_detail.dart';
import 'package:tellyea/model/YeetModel.dart';
import 'package:tellyea/common/theme.dart';
import 'package:tellyea/main.dart';

import 'package:flutter/material.dart';

class YeetCardWidget extends StatefulWidget {
  final YeetModel yeetModel;

  YeetCardWidget({@required this.yeetModel});

  @override
  _YeetCardWidgetState createState() => _YeetCardWidgetState(yeetModel: yeetModel);
}

class _YeetCardWidgetState extends State<YeetCardWidget> {
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
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Spacer(flex: 1),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              yeetModel.displayname.toUpperCase(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            yeetModel.verified
                                                ? Image.network(
                                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Twitter_Verified_Badge.svg/1200px-Twitter_Verified_Badge.svg.png",
                                                    width: 12.0,
                                                    height: 12.0,
                                                    fit: BoxFit.cover,
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "@" + yeetModel.username,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 98),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    yeetModel.imageUrl,
                                    width: 58.0,
                                    height: 58.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                            // Column(
                            //   children: <Widget>[
                            //     Align(
                            //       alignment: Alignment.centerLeft,
                            //       child: Text(
                            //         "@" + yeetModel.username,
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.normal),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 2.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: 260,
                                    child: Text(
                                      yeetModel.message,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            SmallFunctions.formatFullDateTime(yeetModel.dateTime),
                            style: TextStyle(color: Colors.white),
                          ),
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
