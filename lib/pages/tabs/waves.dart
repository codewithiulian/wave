import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/wavedata.dart';
import 'package:wave/utils/database.dart';

class WavesTab extends StatefulWidget {
  @override
  _WavesTabState createState() => _WavesTabState();
}

class _WavesTabState extends State<WavesTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    buildWaves(BuildContext context, int index, List<WaveData> wave) {
      WaveData _wave = wave[index];
      return Container(
        child: Card(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            children: <Widget>[
              Text(_wave.doneBy)
            ],
          ),
        ),
      );
    }

    return Container(
      child: StreamBuilder<List<WaveData>>(
          stream: DatabaseHelper(uid: user?.uid).waveData,
          builder: (context, snapshot) {
            if(snapshot.hasData){

              return ListView.builder(
                  itemCount: snapshot.data.length,
//                  itemBuilder: (BuildContext context, int index) => buildWaves(context, index, snapshot.data)
                  itemBuilder: (BuildContext context, int index) {
                    WaveData wave = snapshot.data[index];
                    return Container(
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text(wave.doneBy)
                          ],
                        )
                      ),
                    );
                  }

              );
            }else {
              return Container();
            }
          }),
    );
  }
}
