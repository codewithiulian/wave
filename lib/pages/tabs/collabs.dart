import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/models/wavedata.dart';
import 'package:wave/utils/database.dart';
import 'package:wave/utils/helper.dart';

class CollabsTab extends StatefulWidget {
  @override
  _CollabsTabState createState() => _CollabsTabState();
}

class _CollabsTabState extends State<CollabsTab> {
  DatabaseHelper _databaseHelper;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final userProfile = Provider.of<UserProfile>(context);

    if (user != null && userProfile != null) {
      _databaseHelper = DatabaseHelper(uid: user.uid);
      return Container(
        child: StreamBuilder<List<WaveData>>(
            stream: _databaseHelper.collabWaveData,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildWaves(context, index, snapshot.data,
                            userProfile.accountType == 'Waver'));
              } else {
                return _showNoDataContainer(userProfile.fullName);
              }
            }),
      );
    }
    return _showNoDataContainer(userProfile.fullName);
  }

  Widget _buildWaves(
      BuildContext context, int index, List<WaveData> wave, bool isWaver) {
    WaveData _wave = wave[index];
    bool isComplete = _wave.status == 'Complete';

    return Container(
      child: Card(
        color: isComplete ? Colors.green[200] : Colors.indigo[100],
        elevation: 4,
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
                    isWaver ? _wave.lancerName : _wave.waverName,
                    style: TextStyle(
                        fontSize: 17.5, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isWaver && !isComplete,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async =>
                          await _completeCollab(_wave.documentId),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.check, color: Colors.indigo),
                          Text('Complete')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isComplete,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.check, color: Colors.indigo),
                    Text('Complete')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _completeCollab(String waveDocumentId) async {
    return await _databaseHelper.completeWave(waveDocumentId);
  }

  Widget _showNoDataContainer(String userFullName) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'This is where you see any active Collabs.',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'There is nothing here yet. Start collaborating on a wave.',
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
