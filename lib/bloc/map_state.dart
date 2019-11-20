import 'package:meta/meta.dart';

@immutable
abstract class MapState {
  MapState([List props = const []]) : super();
}

class InitialMapState extends MapState {}

class LocationFound extends MapState {
  final curLoc;

  LocationFound(this.curLoc) : super([curLoc]);
}

class Loading extends MapState {}

class Failure extends MapState {}
