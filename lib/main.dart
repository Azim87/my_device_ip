import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_ip/bloc/connection_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ConnectionBloc()..add(CheckConnectionEvent()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('MyIP'),
          ),
          body: ConnectionBody(),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class ConnectionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: BlocBuilder<ConnectionBloc, NetworkState>(
            builder: (context, state) {
          if (state is ConnectionLoadingState) {
            EasyLoading.show();
          }
          if (state is ConnectionErrorState) {
            EasyLoading.dismiss();
            print('not connected');
            return Center(
              child: Text(state.error),
            );
          }
          if (state is ConnectionSuccessState) {
            EasyLoading.show();
            BlocProvider.of<ConnectionBloc>(context).add(FetchMyIpEvent());
            return Center(
              child: Text("You're Connected to Internet"),
            );
          }
          if (state is MyIpSuccessState) {
            EasyLoading.dismiss();
            return Center(
              child: Text(state.ip),
            );
          } else {
            return Text('');
          }
        }),
      ),
    );
  }
}
