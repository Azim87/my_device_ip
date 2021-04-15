import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';
import 'package:meta/meta.dart';

part 'connection_event.dart';

part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, NetworkState> {
  ConnectionBloc() : super(ConnectionInitialState());

  StreamSubscription _subscription;

  @override
  Stream<NetworkState> mapEventToState(
    ConnectionEvent event,
  ) async* {
    if (event is CheckConnectionEvent) {
      yield ConnectionLoadingState();
      try {
        _subscription = DataConnectionChecker().onStatusChange.listen((status) {
          add(
            ConnectionChangedEvent(
              connectionState: status == DataConnectionStatus.disconnected
                  ? ConnectionErrorState(error: 'disconnected')
                  : ConnectionSuccessState(),
            ),
          );
        });
      } catch (ex) {
        yield ConnectionErrorState(error: ex.toString());
      }
    } else if (event is ConnectionChangedEvent) {
      yield event.connectionState;
    } else if (event is FetchMyIpEvent) {
      yield ConnectionLoadingState();
      try {
        final ipAddress = await GetIp.ipAddress;
        yield MyIpSuccessState(ip: ipAddress);
      } on PlatformException {
        yield ConnectionErrorState(error: "Failed to get ip address");
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
