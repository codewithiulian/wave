import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:money_field/money_field.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/collabtype.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/wavedata.dart';
import 'package:wave/utils/database.dart';

class WaveEditor extends StatefulWidget {
  @override
  _WaveEditorState createState() => _WaveEditorState();
}

enum CollabType { Errands, Cleaning, Cooking, Babysitting }

class _WaveEditorState extends State<WaveEditor> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _collabTypes = [
    'Errands',
    'Cleaning',
    'Cooking',
    'Babysitting',
    'Handy Man',
    'Furniture Fitting',
    'Moving Out'
  ];

  final TextEditingController _addressController = TextEditingController();
  final MoneyFieldController _budgetController = MoneyFieldController();

  String _currentAddress = '';
  DateTime _currentDeadline;
  String _currentCollabType;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final _db = DatabaseHelper(uid: user?.uid);

    Future _addWave() async {
      DateTime selectedDate =
          _currentDeadline ?? DateTime.now().add(Duration(days: 1));
      WaveData waveData = WaveData();
      waveData.collabType = _currentCollabType ?? _collabTypes[0];
      waveData.address = _currentAddress;
      waveData.budget = _budgetController.doubleValue();
      waveData.doneBy = selectedDate.toString();
      waveData.createdOn = DateTime.now().toString();
      waveData.createdBy = user?.displayName;
      await _db.addWave(user?.uid, waveData);
    }

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'Wave lancers',
                    style: TextStyle(
                        fontSize: 23.0, fontWeight: FontWeight.normal),
                  ),
                ),
                Tooltip(
                  textStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  message:
                      'Waving means instantly notifying lancers in your area you need help on a task.',
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.indigo,
                    size: 20.0,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 300.0,
                    child: DropdownButtonFormField(
                        items: _collabTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text('$type'),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _currentCollabType = val),
                        value: _currentCollabType ?? _collabTypes[0]),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    width: 300.0,
                    child: TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.pin_drop),
                          hintText:
                              '1-13 St Giles High St, West End, London WC2H 8AG'),
                      validator: (val) =>
                          val.isEmpty ? 'Please enter your address' : null,
                      onChanged: (val) => setState(() => _currentAddress = val),
                    ),
                  ),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Budget',
                            prefixIcon: Icon(Icons.attach_money),
                            hintText: '30.0'),
                        validator: (_) {
                          return _budgetController.moneyFieldValidator();
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: FlatButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            // Earliest deadline is now
                            maxTime: DateTime.now().add(Duration(days: 30)),
                            // Latest in one month time.
                            onConfirm: (date) {
                          setState(() {
                            _currentDeadline = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: FlatButton(
                          child: Row(
                        children: <Widget>[
                          Text('Done by:'),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.indigo,
                          ),
                        ],
                      )),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      child: Row(children: <Widget>[
                        Icon(
                          FontAwesome5.hand_paper,
                          color: Colors.indigo,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            'wave',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      ]),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await _addWave();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
