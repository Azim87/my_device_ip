part of 'connection_bloc.dart';

@immutable
abstract class ConnectionEvent {}

class CheckConnectionEvent extends ConnectionEvent {}

class ConnectionChangedEvent extends ConnectionEvent {
  final NetworkState connectionState;

  ConnectionChangedEvent({@required this.connectionState});
}

class FetchMyIpEvent extends ConnectionEvent {}
