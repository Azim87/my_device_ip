import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _ip = 'Unknown';
  String connectionType = "";
  StreamSubscription streamConnectionStatus;
  bool boolHasConnection = false;

  @override
  void initState() {
    super.initState();
    getConnectionStatus();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String ipAddress;
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress.';
    }
    if (!mounted) return;

    setState(() {
      _ip = ipAddress;
    });
  }

  Future<Null> getConnectionStatus() async {
    streamConnectionStatus = new Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      debugPrint(result.toString());

      if (result == ConnectivityResult.mobile) {
        print('mobile');
        setState(() {
          connectionType = 'mobile network';
          boolHasConnection = true;
        });
        if (boolHasConnection) {
          initPlatformState();
        }
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          connectionType = 'wi-fi';
          boolHasConnection = true;
        });
        if (boolHasConnection) {
          initPlatformState();
        }
      } else {
        setState(() {
          boolHasConnection = false;
          connectionType = "";
          _ip = "";
        });
      }
    });
  }

  @override
  void dispose() {
    try {
      streamConnectionStatus?.cancel();
    } catch (exception) {
      print(exception.toString());
    } finally {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MyIP'),
        ),
        body: boolHasConnection
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            'The device ip is: $_ip\n',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text('connected to: $connectionType'),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Text('No connection'),
              ),
      ),
    );
  }
}
