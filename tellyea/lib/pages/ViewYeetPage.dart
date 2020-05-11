import 'package:TellYea/common/YeetCard.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:TellYea/common/theme.dart';
import 'package:flutter/material.dart';

class YeetDetail extends StatefulWidget {
  final YeetModel yeet;

  YeetDetail({@required this.yeet});

  @override
  YeetDetailState createState() => new YeetDetailState();
}

class YeetDetailState extends State<YeetDetail> {
  Color colorScheme;
  @override
  void initState() {
    super.initState();
    colorScheme = ColorSchemes.getColorSchemeFromUser(widget.yeet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          Hero(
            tag: widget.yeet.id,
            child: YeetCardWidget(yeetModel: widget.yeet),
          ),
          Spacer(),
          SizedBox(height: 80.0),
        ],
      ),
    );
  }
}
