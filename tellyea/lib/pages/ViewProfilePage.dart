import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/model/Profile.dart';
import 'package:flutter/material.dart';

import 'package:TellYea/common/theme.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;
  ProfilePage({this.profile});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile profile;
  List<YeetModel> yeetModels = new List<YeetModel>();

  @override
  void initState() {
    if (widget.profile == null) {
      profile = new Profile(displayname: ThisUser.displayname, bio: ThisUser.bio, colorScheme: ColorSchemes.colorSchemesToColor(ThisUser.colorScheme), username: ThisUser.username, imageUrl: ThisUser.imageUrl, verified: ThisUser.verified);
      loadYeets();
      return;
    }
    profile = widget.profile;
    loadYeets();
    super.initState();
  }

  void loadYeets() {
    for (var i = 0; i < Yeets.yeetModels.length; i++) {
      if (Yeets.yeetModels[i].username == profile.username) {
        yeetModels.add(new YeetModel(id: i.toString(), dateTime: Yeets.yeetModels[i].dateTime, colorScheme: Yeets.yeetModels[i].colorScheme, displayname: Yeets.yeetModels[i].displayname, username: Yeets.yeetModels[i].username, imageUrl: Yeets.yeetModels[i].imageUrl, message: Yeets.yeetModels[i].message, verified: Yeets.yeetModels[i].verified, objectId: Yeets.yeetModels[i].objectId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                SizedBox(width: 5),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      profile.displayname,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.accountMultiplePlus),
                  onPressed: () {
                    print('test');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    print('test');
                  },
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              SizedBox(width: 15),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      'https://m.media-amazon.com/images/I/81J+-QFsYuL._SS500_.jpg',
                      width: 90.0,
                      height: 90.0,
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
                        'User Since 2020',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
            padding: EdgeInsets.only(left: 10),
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
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          SizedBox(width: 2),
                          profile.verified
                              ? Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Twitter_Verified_Badge.svg/1200px-Twitter_Verified_Badge.svg.png",
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
                      height: 80,
                      width: 180,
                      child: Text(
                        profile.bio,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // return Container(
          //   child: ListView.builder(
          //     itemCount: yeetModels.length,
          //     padding: EdgeInsets.only(top: 20),
          //     itemBuilder: (context, index) {
          //       return Hero(tag: yeetModels[index].id, child: YeetCardWidget(yeetModel: yeetModels[index]));
          //     },
          //   ),
          // );
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () => print('Loading Yeets'), // TODO: nav to user yeets
                  child: Text('Yeets by ${yeetModels[0].displayname}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
