part of 'connection_bloc.dart';

@immutable
abstract class NetworkState {}

class ConnectionInitialState extends NetworkState {}

class ConnectionLoadingState extends NetworkState {}

class ConnectionSuccessState extends NetworkState {}

class ConnectionErrorState extends NetworkState {
  final String error;

  ConnectionErrorState({@required this.error});
}

class MyIpSuccessState extends NetworkState {
  final String ip;
  MyIpSuccessState({@required this.ip});
}
