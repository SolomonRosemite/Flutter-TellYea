import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/common/FadePageRoute.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:TellYea/pages/ViewYeetPage.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/common/theme.dart';
import 'package:TellYea/main.dart';

import 'package:flutter/material.dart';

class YeetCardWidget extends StatefulWidget {
  final YeetModel yeetModel;

  YeetCardWidget({@required this.yeetModel});

  @override
  YeetCardWidgetState createState() => YeetCardWidgetState();
}

class YeetCardWidgetState extends State<YeetCardWidget> {
  static String bio;
  static DateTime created;

  Color colorScheme;

  @override
  void initState() {
    super.initState();
    colorScheme = ColorSchemes.getColorSchemeFromUser(widget.yeetModel.ownerId);

    // Backend.save("Reports", {
    //   "user": "ownerId",
    //   "colorScheme": colorScheme
    // });
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
          color: colorScheme,
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
                                                // true
                                                ? Image.asset(
                                                    "images/Verified_Badge.png",
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
                                  onTapUp: (_) {
                                    if (widget.yeetModel.ownerId == ThisUser.ownerId) return;

                                    for (var item in Backend.tellYeaUsers) {
                                      if (item['username'] == widget.yeetModel.username) {
                                        bio = item['bio'];
                                        created = item['created'];
                                        break;
                                      }
                                    }

                                    // Assign values to ProfilePageState.profile
                                    ProfilePageState.profile.bio = bio;
                                    ProfilePageState.profile.created = created;
                                    ProfilePageState.profile.colorScheme = colorScheme;
                                    ProfilePageState.profile.displayname = widget.yeetModel.displayname;
                                    ProfilePageState.profile.imageUrl = widget.yeetModel.imageUrl;
                                    ProfilePageState.profile.username = widget.yeetModel.username;
                                    ProfilePageState.profile.ownerId = widget.yeetModel.ownerId;
                                    ProfilePageState.profile.verified = widget.yeetModel.verified;

                                    // Move over the Profile page
                                    YeetListPageState.tabController.animateTo(0);
                                  },
                                  child: ClipRRect(
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
                                SizedBox(height: 1.0),
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
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  SmallFunctions.formatDateTimeDayMonthTime(widget.yeetModel.dateTime),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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
