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
  Color activeColor = Colors.blue[600];
  Color unactiveColor = Colors.blue[300];
  bool showFollowers = false;

  List<UserModel> followers = [];
  List<UserModel> following = [];

  @override
  void initState() {
    // Demo
    var users = getUsers();
    followers.addAll(splitFollowers(users));
    following.addAll(loadMyFollows(users));
    super.initState();
  }

  bool showSpacer() {
    if (showFollowers) {
      return followers.isEmpty;
    }

    return following.isEmpty;
  }

  List<UserModel> getUsers() {
    List<UserModel> users = [];

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
    List<UserModel> usersList = [];

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
    if (followers.length == 0) {
      return Center(
        child: Container(
          child: Text(
            "No current followers...",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    List<Widget> list = [];
    for (var i = followers.length - 1; 0 <= i; i--) {
      list.add(Hero(tag: (i).toString(), child: ProfileCardWidget(profileModel: followers[i], key: UniqueKey())));
    }
    return new Column(children: list);
  }

  Widget followingWidget() {
    if (following.length == 0) {
      return Center(
        child: Container(
          child: Text(
            "Current not following anyone...",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    List<Widget> list = [];
    for (var i = following.length - 1; 0 <= i; i--) {
      list.add(Hero(tag: (i * 2).toString(), child: ProfileCardWidget(profileModel: following[i], key: UniqueKey())));
    }
    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Container(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() => showFollowers = true);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                // side: BorderSide(color: Colors.red),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              (showFollowers == true) ? activeColor : unactiveColor,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Followers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => showFollowers = false);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                // side: BorderSide(color: Colors.red),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              (showFollowers == true) ? unactiveColor : activeColor,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Following',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    showSpacer() ? Spacer() : SizedBox.shrink(),
                    (showFollowers == true) ? followersWidget() : followingWidget(),
                    showSpacer() ? Spacer() : SizedBox.shrink(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
