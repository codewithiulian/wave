import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class WaveEditor extends StatefulWidget {
  @override
  _WaveEditorState createState() => _WaveEditorState();
}

class _WaveEditorState extends State<WaveEditor> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('This is where you edit and create Waves')
    );
  }
}
