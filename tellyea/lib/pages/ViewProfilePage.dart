import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:TellYea/pages/Settings/Preferences.dart';
import 'package:TellYea/backend/SmallFunctions.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:TellYea/model/Profile.dart';
import 'package:TellYea/common/theme.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = "/ProfilePage";

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<YeetModel> yeetModels = [];
  static Profile profile = new Profile();

  @override
  void initState() {
    if (profile.bio == null) {
      profile.bio = ThisUser.bio;
      profile.created = ThisUser.created;
      profile.colorScheme = ColorSchemes.colorSchemesToColor(ThisUser.colorScheme);
      profile.displayname = ThisUser.displayname;
      profile.imageUrl = ThisUser.imageUrl;
      profile.username = ThisUser.username;
      profile.ownerId = ThisUser.ownerId;
      profile.verified = ThisUser.verified;
      loadYeets();
      return;
    }
    loadYeets();
    super.initState();
  }

  void loadYeets() {
    for (var i = 0; i < Yeets.yeetModels.length; i++) {
      if (Yeets.yeetModels[i].username == profile.username) {
        yeetModels.add(new YeetModel(id: i.toString(), dateTime: Yeets.yeetModels[i].dateTime, ownerId: Yeets.yeetModels[i].ownerId, displayname: Yeets.yeetModels[i].displayname, username: Yeets.yeetModels[i].username, imageUrl: Yeets.yeetModels[i].imageUrl, message: Yeets.yeetModels[i].message, verified: Yeets.yeetModels[i].verified));
      }
    }
    yeetModels.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  Widget heroWidgets() {
    List<Widget> list = [];
    for (var i = yeetModels.length - 1; 0 <= i; i--) {
      list.add(new Hero(tag: yeetModels[i].id, child: YeetCardWidget(yeetModel: yeetModels[i])));
    }
    list.insert(
        0,
        Text(
          'Yeets by ${yeetModels[0].displayname}',
          style: TextStyle(color: Colors.white),
        ));
    return new Column(children: list);
  }

  void updateFollowingList() {
    Backend.update(
      'TellYeaUsers',
      {
        'bio': ThisUser.bio,
        'colorScheme': ThisUser.colorScheme,
        'displayname': ThisUser.displayname,
        'following': ThisUser.following,
        'imageUrl': ThisUser.imageUrl,
        'username': ThisUser.username,
      },
      'ownerId =\'${ThisUser.ownerId}\'',
    );

    Backend.save(
      'TellYeaUsersUpdater',
      {
        'bio': ThisUser.bio,
        'colorScheme': ThisUser.colorScheme,
        'displayname': ThisUser.displayname,
        'following': ThisUser.following,
        'imageUrl': ThisUser.imageUrl,
        'username': ThisUser.username,
      },
    );
  }

  @override
  void dispose() {
    profile = new Profile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Container(
            color: profile.colorScheme,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(MdiIcons.messageDraw), onPressed: () => Navigator.pushNamed(context, Preferences.routeName)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            profile.displayname,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      (profile.ownerId != ThisUser.ownerId)
                          ? (!ThisUser.following.contains(profile.ownerId))
                              ? IconButton(
                                  icon: Icon(MdiIcons.accountMultiplePlus),
                                  onPressed: () {
                                    setState(() {
                                      if (ThisUser.following.length == 0) {
                                        ThisUser.following += profile.ownerId;
                                      } else {
                                        ThisUser.following += ',' + profile.ownerId;
                                      }
                                    });
                                    updateFollowingList();
                                  },
                                )
                              : IconButton(
                                  icon: Icon(MdiIcons.accountMultipleRemove),
                                  onPressed: () {
                                    setState(() {
                                      if (!ThisUser.following.contains(',')) {
                                        ThisUser.following = '';
                                      } else {
                                        ThisUser.following = ThisUser.following.replaceFirst(yeetModels.first.ownerId, '');
                                      }
                                    });
                                    updateFollowingList();
                                  },
                                )
                          : SizedBox.shrink(),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                profile.imageUrl,
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  yeetModels.length.toString(),
                                  style: TextStyle(fontSize: 30, color: Colors.white),
                                ),
                                Text(
                                  'Total Yeets',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'User Since ${SmallFunctions.formatDateTimeMonthYear(profile.created)}',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '@' + profile.username,
                                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 2),
                                    profile.verified
                                        ? Image.asset(
                                            "images/Verified_Badge.png",
                                            width: 11.0,
                                            height: 11.0,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 78,
                                width: 180,
                                child: Text(
                                  profile.bio,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            yeetModels.length != 0 ? heroWidgets() : SizedBox.shrink(),
                            SizedBox(height: 65),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
