import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/wavedata.dart';
import 'package:wave/utils/database.dart';
import 'package:intl/intl.dart';

class WavesTab extends StatefulWidget {
  @override
  _WavesTabState createState() => _WavesTabState();
}

class _WavesTabState extends State<WavesTab> {
  IconData getIcon(String _collabType) {
    switch (_collabType) {
      case 'Errands':
        return MaterialCommunityIcons.run;
      case 'Cleaning':
        return MaterialCommunityIcons.silverware_clean;
      case 'Cooking':
        return MaterialCommunityIcons.chef_hat;
      case 'Babysitting':
        return MaterialCommunityIcons.human_child;
      case 'Handy Man':
        return MaterialCommunityIcons.hammer;
      case 'Furniture Fitting':
        return MaterialCommunityIcons.sofa;
      case 'Moving Out':
        return MaterialCommunityIcons.home;
      default:
        return Icons.work;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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
                        Icon(getIcon(_wave.collabType),
                            size: 40.0, color: Colors.indigo),
                        Padding(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              _wave.collabType,
                              style: TextStyle(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.normal),
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

    return Container(
      child: StreamBuilder<List<WaveData>>(
          stream: DatabaseHelper(uid: user?.uid).waveData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildWaves(context, index, snapshot.data));
            } else {
              return Container();
            }
          }),
    );
  }
}
