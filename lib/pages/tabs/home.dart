import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final UserProfile userProfile = Provider.of<UserProfile>(context);

    if (userProfile != null) {
      if (userProfile.accountType == 'Lancer') {
        return Container(
          child: StreamBuilder<List<WaveData>>(
              stream: DatabaseHelper().userWaveData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildWaves(context, index, snapshot.data));
                }
                return Container();
              }),
        );
      }
    }
    return Container();
  }

  buildWaves(BuildContext context, int index, List<WaveData> wave) {
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
          ],
        ),
      ),
    );
  }
}
