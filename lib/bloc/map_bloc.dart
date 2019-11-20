import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  @override
  MapState get initialState => InitialMapState();

  var loc;

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    //
    // After demanding GetLocation in main.dart (via bloc.add()) return location state value to LocationFound for use
    //
    if (event is GetLocation) {
      yield* _getLocationToState();
    }
  }

  Stream<MapState> _getLocationToState() async* {
    try {
      var location = await Geolocator().getCurrentPosition();
      print('Current location: $location');

      loc = location;

      yield LocationFound(location);
    } catch (_) {
      yield Failure();
    }
  }
}
