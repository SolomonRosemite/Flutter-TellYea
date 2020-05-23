import 'package:TellYea/model/UserModel.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/common/theme.dart';
import 'package:flutter/material.dart';

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
    followers.add(new UserModel(username: 'followers'));
    followers.add(new UserModel(username: 'followers'));
    followers.add(new UserModel(username: 'followers'));
    following.add(new UserModel(username: 'following'));
    following.add(new UserModel(username: 'following'));
    following.add(new UserModel(username: 'following'));
    // followers.addAll(getUsers());
    // following.add(value);
    super.initState();
  }

  List<UserModel> getUsers() {
    List<UserModel> users = new List<UserModel>();
    print('object');
    for (var i = 0; i < Backend.tellYeaUsers.length; i++) {
      print('object2');
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
    List<Widget> list = new List<Widget>();
    for (var i = followers.length - 1; 0 <= i; i--) {
      list.add(new Text(followers[i].username));
    }
    return new Column(children: list);
  }

  Widget followingWidget() {
    List<Widget> list = new List<Widget>();
    for (var i = following.length - 1; 0 <= i; i--) {
      list.add(new Text(following[i].username));
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
                        setState(() {
                          showFollowers = true;
                        });
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
                        setState(() {
                          showFollowers = false;
                        });
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
              ],
            ),
          ),
        ),
      );
    });
  }
}
