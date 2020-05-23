import 'package:TellYea/common/ProfileCard.dart';
import 'package:TellYea/model/ThisUser.dart';
import 'package:TellYea/model/UserModel.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/common/theme.dart';
import 'package:flutter/material.dart';

enum FollowMode { followers, following }

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  bool showFollowers = true;

  List<UserModel> followers = new List();
  List<UserModel> following = new List();

  @override
  void initState() {
    // Demo
    var users = getUsers();
    followers.addAll(splitFollowers(users));
    following.addAll(loadMyFollows(users));
    super.initState();
  }

  List<UserModel> getUsers() {
    List<UserModel> users = new List<UserModel>();

    for (var i = 0; i < Backend.tellYeaUsers.length; i++) {
      users.add(new UserModel(
        bio: Backend.tellYeaUsers[i]['bio'],
        colorScheme: ColorSchemes.colorSchemesToColor(Backend.tellYeaUsers[i]['colorScheme']),
        created: Backend.tellYeaUsers[i]['created'],
        displayname: Backend.tellYeaUsers[i]['displayname'],
        following: Backend.tellYeaUsers[i]['following'],
        imageUrl: Backend.tellYeaUsers[i]['imageUrl'],
        username: Backend.tellYeaUsers[i]['username'],
        verified: Backend.tellYeaUsers[i]['verified'],
        ownerId: Backend.tellYeaUsers[i]['ownerId'],
      ));
    }

    return users;
  }

  List<UserModel> splitFollowers(List<UserModel> list) {
    List<UserModel> usersList = new List();

    for (var i = 0; i < list.length; i++) {
      if (list[i].following == null) continue;

      if (list[i].following.contains(ThisUser.ownerId)) {
        usersList.add(list[i]);
      }
    }

    return usersList;
  }

  List<UserModel> loadMyFollows(List<UserModel> list) {
    for (var i = 0; i < list.length; i++) {
      if (!ThisUser.following.contains(list[i].ownerId)) {
        list.removeAt(i--);
      }
    }
    return list;
  }

  Widget followersWidget() {
    List<Widget> list = new List<Widget>();
    for (var i = followers.length - 1; 0 <= i; i--) {
      list.add(Hero(tag: i, child: ProfileCardWidget(profileModel: followers[i])));
    }
    return new Column(children: list);
  }

  Widget followingWidget() {
    List<Widget> list = new List<Widget>();
    for (var i = following.length - 1; 0 <= i; i--) {
      list.add(Hero(tag: i, child: ProfileCardWidget(profileModel: following[i])));
    }
    return new Column(children: list);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() => showFollowers = true);
                      },
                      child: Text(
                        'Followers',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() => showFollowers = false);
                      },
                      child: Text(
                        'Following',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                (showFollowers == true) ? followersWidget() : followingWidget(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
