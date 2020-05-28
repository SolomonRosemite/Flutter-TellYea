import 'package:TellYea/pages/Settings/ExtraPreferencesPage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:TellYea/backend/SharedPreferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:TellYea/pages/YeetListPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:TellYea/backend/backend.dart';
import 'package:TellYea/model/ThisUser.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class Save {
  static String bio;
  static String colorScheme;
  static String displayname;
  static String following;
  static String imageUrl;
  static String username;

  static Future<void> save({
    @required String bio,
    @required String colorScheme,
    @required String displayname,
    @required String following,
    @required String imageUrl,
    @required String username,
  }) async {
    ThisUser.bio = bio;
    ThisUser.colorScheme = colorScheme;
    ThisUser.displayname = displayname;
    ThisUser.imageUrl = imageUrl;
    ThisUser.username = username;

    // Save to Database
    Backend.update(
      'TellYeaUsers',
      {
        'bio': bio,
        'colorScheme': colorScheme,
        'displayname': displayname,
        'following': following,
        'imageUrl': imageUrl,
        'username': username,
      },
      'ownerId =\'${ThisUser.ownerId}\'',
    );

    await Backend.saveAsync(
      'TellYeaUsersUpdater',
      {
        'bio': bio,
        'colorScheme': colorScheme,
        'displayname': displayname,
        'following': following,
        'imageUrl': imageUrl,
        'username': username,
      },
    );
  }
}

class Preferences extends StatefulWidget {
  static const String routeName = "/Preferences";

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  bool savedTemp = false;
  bool timeout = false;

  String image;

  @override
  void initState() {
    if (savedTemp != true) {
      image = ThisUser.imageUrl;
      Save.bio = ThisUser.bio;
      Save.colorScheme = ThisUser.colorScheme;
      Save.displayname = ThisUser.displayname;
      Save.following = ThisUser.following;
      Save.imageUrl = ThisUser.imageUrl;
      Save.username = ThisUser.username;
      savedTemp = true;
    }
    super.initState();
  }

  bool noChange() {
    if (Save.bio != ThisUser.bio) {
      return false;
    } else if (Save.colorScheme != ThisUser.colorScheme) {
      return false;
    } else if (Save.displayname != ThisUser.displayname) {
      return false;
    } else if (Save.imageUrl != ThisUser.imageUrl) {
      return false;
    } else if (Save.username != ThisUser.username) {
      return false;
    }

    return true;
  }

  void saveImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    var cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square
            ]
          : [
              CropAspectRatioPreset.square
            ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );

    if (cropped == null) return;

    image = cropped;

    // Compress Image
    image = await FlutterNativeImage.compressImage(
      image.path,
      quality: 55,
      percentage: 60,
    );

    Save.imageUrl = await Backend.uploadImage(image);

    setState(() {
      this.image = Save.imageUrl;
    });
  }

  void closePage() => Navigator.of(context).pop();

  void showMyDialog({
    String title = 'Unsaved Settings',
    String content = 'Are you sure you don\'t want to Save?',
    String confirmText = 'Don\'t Save',
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: new Text(title), content: new Text(content), actions: <Widget>[
          new FlatButton(
            child: new Text('Go Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
              color: Colors.red,
              child: new Text(
                confirmText,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                closePage();
              }),
        ]);
      },
    );
  }

  Widget settingsbutton({@required String context, @required Function() callback, Alignment textAlignment = Alignment.centerLeft, Color textColor = Colors.white, FontWeight fontWeight = FontWeight.normal, double fontSize = 15, double height = 50}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 0,
          width: double.infinity,
          child: Container(color: Colors.grey),
        ),
        Container(
          width: double.infinity,
          height: height,
          child: RaisedButton(
            color: Colors.white,
            elevation: 0,
            onPressed: () => callback(),
            child: Container(
              alignment: textAlignment,
              child: Text(
                context,
                style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
            icon: new Icon(Icons.close, size: 25, color: Colors.red[300]),
            onPressed: () {
              if (noChange() == true) {
                Navigator.of(context).pop(null);
                return;
              }
              showMyDialog();
            }),
        title: Text(
          "Preferences",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 5,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.done, size: 25, color: Colors.blue[300]),
              onPressed: () async {
                if (timeout != true) {
                  timeout = true;
                  if (noChange() == true) {
                    Navigator.of(context).pop(null);
                    return;
                  }

                  // Update Profile
                  await Save.save(
                    bio: Save.bio,
                    colorScheme: Save.colorScheme,
                    following: Save.following,
                    displayname: Save.displayname,
                    imageUrl: Save.imageUrl,
                    username: Save.username,
                  );

                  // Update all Yeets made by this User
                  Backend.update(
                    'Yeets',
                    {
                      'displayname': Save.displayname,
                      'imageUrl': Save.imageUrl,
                      'username': Save.username,
                    },
                    'ownerId = \'${ThisUser.ownerId}\'',
                  );

                  YeetListPageState.tabController.index = 0;
                  Navigator.of(context).pop();
                }
              })
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              '${Save.displayname}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () => saveImage(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  image,
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            FlatButton(
              onPressed: () => saveImage(),
              child: Text(
                'Change Profile Picture',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Spacer(flex: 1000),
            settingsbutton(
                callback: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text('ColorScheme'),
                      message: Text('Pick a ColorScheme'),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Save.colorScheme = 'primaryColor';
                              Navigator.pop(context);
                            },
                            child: Text('Blue')),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Save.colorScheme = 'red';
                              Navigator.pop(context);
                            },
                            child: Text('Red'))
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel', style: TextStyle(color: Colors.red[300]))),
                    ),
                  );
                },
                context: 'Pick your ColorScheme',
                textAlignment: Alignment.center,
                fontSize: 15,
                textColor: Colors.black),
            settingsbutton(callback: () => Navigator.pushNamed(context, ExtraPreferencesPage.routeName), context: 'Edit Name and Bio', textAlignment: Alignment.center, fontSize: 15, textColor: Colors.black),
            settingsbutton(
                callback: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(title: new Text('Logout'), content: new Text('Are you sure you want to Logout?'), actions: <Widget>[
                        new FlatButton(
                          child: new Text('Go Back'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                            color: Colors.red,
                            child: new Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              MySharedPreferences.prefs.clear();
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(title: new Text('Logout'), content: new Text('You will be Logged off after\nrestarting the App.'), actions: <Widget>[
                                    new FlatButton(
                                      child: new Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                                },
                              );
                            }),
                      ]);
                    },
                  );
                },
                context: 'Logout',
                textAlignment: Alignment.center,
                fontSize: 15,
                textColor: Colors.red[300]),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
