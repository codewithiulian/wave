import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/models/wavedata.dart';
import 'package:wave/utils/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/utils/helper.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DatabaseHelper _db;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final UserProfile userProfile = Provider.of<UserProfile>(context);

    if (user != null && userProfile != null) {
      _db = DatabaseHelper(uid: user.uid);
      if (userProfile.accountType == 'Lancer') {
        return Container(
          child: StreamBuilder<List<WaveData>>(
              stream: _db.waveData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildWaves(context, index, snapshot.data, user.uid));
                }
                return Container();
              }),
        );
      }
    }
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Hi ${user?.displayName}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'This is where you see Lancers around your area.',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Unfortunately there is nothing here yet for Wavers, but will be in the nearest future. Feel free to add a wave by clicking the plus button at the bottom of the screen.',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  buildWaves(
      BuildContext context, int index, List<WaveData> wave, String lancerId) {
    WaveData _wave = wave[index];

    return Container(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Helper.getCollaborationIcon(_wave.collabType),
                          size: 40.0, color: Colors.indigo),
                      Padding(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Text(
                            _wave.collabType,
                            style: TextStyle(
                                fontSize: 18.5, fontWeight: FontWeight.normal),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.attach_money, color: Colors.indigo),
                  Text(
                    _wave.budget.toString(),
                    style: TextStyle(
                        fontSize: 17.5, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.location_city, color: Colors.indigo),
                  Text(
                    _wave.address,
                    style: TextStyle(
                        fontSize: 17.5, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.calendar_today, color: Colors.indigo),
                  Text(
                    _wave.doneBy,
                    style: TextStyle(
                        fontSize: 17.5, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.person, color: Colors.indigo),
                  Text(
                    _wave.createdBy,
                    style: TextStyle(
                        fontSize: 17.5, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Icon(MaterialCommunityIcons.thumb_up,
                              color: Colors.indigo),
                        ),
                        Text(
                          'Collab',
                          style: TextStyle(
                              fontSize: 17.5, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    onPressed: () async =>
                        await _collabWave(lancerId, _wave.documentId),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _collabWave(String lancerId, String waveDocumentId) async {
    return await _db.collabWave(lancerId, waveDocumentId);
  }
}
