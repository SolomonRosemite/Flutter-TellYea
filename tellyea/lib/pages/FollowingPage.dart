import 'package:TellYea/model/UserModel.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/common/theme.dart';
import 'package:flutter/material.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  bool showFollowers = false;

  List<UserModel> followers = new List();
  List<UserModel> following = new List();

  @override
  void initState() {
    // Demo
    followers.addAll(getUsers());
    // following.add(value);
    super.initState();
  }

  List<UserModel> getUsers() {
    List<UserModel> users = new List<UserModel>();
    for (var i = 0; i < Backend.tellYeaUsers.length; i++) {
      users.add(new UserModel(
        bio: Backend.tellYeaUsers[i]['bio'],
        colorSchemem: ColorSchemes.colorSchemesToColor(Backend.tellYeaUsers[i]['colorSchemem']),
        created: Backend.tellYeaUsers[i]['created'],
        displayname: Backend.tellYeaUsers[i]['displayname'],
        // following: , // TODO
        imageUrl: Backend.tellYeaUsers[i]['imageUrl'],
        username: Backend.tellYeaUsers[i]['username'],
        verified: Backend.tellYeaUsers[i]['verified'],
      ));
    }

    return users;
  }

  Widget followersWidget() {
    return Container(
      child: ListView.builder(
        itemCount: followers.length,
        padding: EdgeInsets.only(top: 20),
        itemBuilder: (context, index) {
          return Text("Hi");
        },
      ),
    );
  }

  Widget followingWidget() {
    return Container(
      child: ListView.builder(
        itemCount: following.length,
        padding: EdgeInsets.only(top: 20),
        itemBuilder: (context, index) {
          return Text("Hi");
        },
      ),
    );
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
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Followers',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Following',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                (showFollowers == true) ? followersWidget() : followingWidget(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
