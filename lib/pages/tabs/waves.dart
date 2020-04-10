import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/models/wavedata.dart';
import 'package:wave/utils/database.dart';
import 'package:wave/utils/helper.dart';

class WavesTab extends StatefulWidget {
  @override
  _WavesTabState createState() => _WavesTabState();
}

class _WavesTabState extends State<WavesTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final userProfile = Provider.of<UserProfile>(context);

    if (user != null &&
        userProfile != null &&
        userProfile?.accountType != 'Lancer') {
      return Container(
        child: StreamBuilder<List<WaveData>>(
            stream: DatabaseHelper(uid: user.uid).userWaveData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildWaves(context, index, snapshot.data));
              } else {
                return Container();
              }
            }),
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Hi ${userProfile.fullName}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'This is where you see any active waves.',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Unfortunately there is nothing here yet for Lancers, but will be in the nearest future. Feel free to collab on any wave found on your Home tab. Wavers are waitign for you.',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaves(BuildContext context, int index, List<WaveData> wave) {
    WaveData _wave = wave[index];

    return Container(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
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
                  Icon(Icons.edit, color: Colors.indigo),
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
          ],
        ),
      ),
    );
  }
}
