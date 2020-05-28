import 'package:TellYea/pages/ViewProfilePage.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:TellYea/model/UserModel.dart';
import 'package:TellYea/backend/backend.dart';

import 'package:flutter/material.dart';

class ProfileCardWidget extends StatefulWidget {
  final UserModel profileModel;

  ProfileCardWidget({@required this.profileModel});

  @override
  ProfileCardWidgetState createState() => ProfileCardWidgetState();
}

class ProfileCardWidgetState extends State<ProfileCardWidget> {
  static String bio;
  static DateTime created;

  Color colorScheme;

  @override
  void initState() {
    super.initState();
    colorScheme = widget.profileModel.colorScheme;
  }

  void navToUser() {
    for (var item in Backend.tellYeaUsers) {
      if (item['username'] == widget.profileModel.username) {
        bio = item['bio'];
        created = item['created'];
        break;
      }
    }
    // Assign values to ProfilePageState.profile
    ProfilePageState.profile.bio = bio;
    ProfilePageState.profile.created = created;
    ProfilePageState.profile.colorScheme = colorScheme;
    ProfilePageState.profile.displayname = widget.profileModel.displayname;
    ProfilePageState.profile.imageUrl = widget.profileModel.imageUrl;
    ProfilePageState.profile.username = widget.profileModel.username;
    ProfilePageState.profile.ownerId = widget.profileModel.ownerId;
    ProfilePageState.profile.verified = widget.profileModel.verified;

    // Move over the Profile page
    YeetListPageState.tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Material(
        color: colorScheme,
        elevation: 20,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: InkWell(
          onTap: () => navToUser(),
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
                                            widget.profileModel.displayname.toUpperCase(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 3),
                                          widget.profileModel.verified
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
                                    "@" + widget.profileModel.username,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Spacer(flex: 98),
                              GestureDetector(
                                onTapUp: (_) => navToUser(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    widget.profileModel.imageUrl,
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
                                    '',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
