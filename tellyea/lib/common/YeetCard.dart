import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/model/Profile.dart';
import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/common/FadePageRoute.dart';
import 'package:TellYea/pages/ViewYeetPage.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/main.dart';

import 'package:flutter/material.dart';

class YeetCardWidget extends StatefulWidget {
  final YeetModel yeetModel;

  YeetCardWidget({@required this.yeetModel});

  @override
  _YeetCardWidgetState createState() => _YeetCardWidgetState();
}

class _YeetCardWidgetState extends State<YeetCardWidget> {
  Profile loadProfile() {
    return new Profile(bio: widget.yeetModel.bio, colorScheme: widget.yeetModel.colorScheme, displayname: widget.yeetModel.displayname, imageUrl: widget.yeetModel.imageUrl, username: widget.yeetModel.username, verified: widget.yeetModel.verified);
  }

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
          color: widget.yeetModel.colorScheme,
          elevation: 20,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: InkWell(
            onTap: () {
              if (MyAppState.onPage == false) {
                Navigator.of(context).push(FadePageRoute(widget: YeetDetail(yeet: widget.yeetModel)));
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
                                              widget.yeetModel.displayname.toUpperCase(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 3),
                                            widget.yeetModel.verified
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
                                      "@" + widget.yeetModel.username,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 98),
                                GestureDetector(
                                  onTapDown: (_) => Navigator.pushNamed(context, ProfilePage.routeName, arguments: loadProfile()),
                                  child: ClipRRect(
                                    // TODO: If user clicks Profile pic. nav to that user.
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      widget.yeetModel.imageUrl,
                                      width: 58.0,
                                      height: 58.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Spacer(flex: 1),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 2.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: 260,
                                    child: Text(
                                      widget.yeetModel.message,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(flex: 1),
                            Spacer(flex: 1000),
                            Text(
                              SmallFunctions.formatFullDateTime(widget.yeetModel.dateTime),
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(flex: 1),
                          ],
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
