import 'package:flutter/material.dart';
import 'package:wave/pages/tabs/components/wave.dart';

class WavesTab extends StatefulWidget {
  @override
  _WavesTabState createState() => _WavesTabState();
}

class _WavesTabState extends State<WavesTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Add a new Wave'),
          RaisedButton(
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
