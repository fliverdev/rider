import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class InitialMapState extends MapState {}

class LocationFound extends MapState {
  final curLoc;

  LocationFound(this.curLoc);
}

class Loading extends MapState {}

class Failure extends MapState {}
