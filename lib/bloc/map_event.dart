import 'package:meta/meta.dart';

@immutable
abstract class MapEvent {
  MapEvent([List props = const []]) : super();
}

class GetLocation extends MapEvent {}
