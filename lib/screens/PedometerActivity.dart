import 'dart:async';

import 'package:bandhu/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';


class PedometerActivity extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  PedometerActivity({
    @required this.userDetails
  });
  @override
  PedometerActivityState createState() => PedometerActivityState();
}

class PedometerActivityState extends State<PedometerActivity> {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    streamDataToFirestore();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() async {
    await Permission.activityRecognition.request();
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  streamDataToFirestore() async {
    DocumentReference userPedometerLogReference = FirebaseFirestore.instance.collection("pedometer").doc(widget.userDetails['email']);
    String todaysDateTime = getDateFromTimestamp(DateTime.now());
    DocumentSnapshot todaysLogs = await userPedometerLogReference.collection("activity").doc(todaysDateTime).get();
    Map<String, dynamic> data = todaysLogs.data();
    if(data != null){
      data['stepCount'] = int.parse(_steps);
      data['updatedAt'] = DateTime.now();
      await userPedometerLogReference.collection("activity").doc(todaysDateTime).set(data);
    } else {
      Map<String, dynamic> newRecord = {};
      newRecord['stepCount'] = int.parse(_steps);
      newRecord['updatedAt'] = DateTime.now();
      await userPedometerLogReference.collection("activity").doc(todaysDateTime).set(newRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Steps taken:',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              _steps,
              style: TextStyle(fontSize: 60),
            ),
            Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            Text(
              'Pedestrian status:',
              style: TextStyle(fontSize: 30),
            ),
            Icon(
              _status == 'walking'
                  ? Icons.directions_walk
                  : _status == 'stopped'
                      ? Icons.accessibility_new
                      : Icons.error,
              size: 100,
            ),
            Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? TextStyle(fontSize: 30)
                    : TextStyle(fontSize: 20, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}