import 'package:flutter/material.dart';
import 'package:rider/bloc/map_bloc.dart';
import 'package:rider/bloc/map_event.dart';
import 'package:rider/bloc/map_state.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:test/test.dart';

void main() {
  MapBloc mapBloc;

  setUp(() {
    mapBloc = MapBloc();
  });

  tearDown(() {
    mapBloc?.close();
  });

  group("BLoC Tests", () {
    test('initial state is correct', () {
      expect(mapBloc.initialState, InitialMapState());
    });

    test('bloc close does not emit new states', () {
      expectLater(mapBloc, emitsInAnyOrder([InitialMapState(), emitsDone]));
      mapBloc.close();
    });

    test('GetLocation returns Failure on empty location', () {
      final expected = [InitialMapState(), Failure()];
      expectLater(mapBloc, emitsInAnyOrder(expected));

      mapBloc.add(GetLocation());
    });
  });

  group("Check if text styles have correct size, color and weight", () {
    test('Title for dark background', () {
      expect(
          MyTextStyles.titleStyleLight,
          TextStyle(
              fontSize: 20,
              color: MyColors.white,
              fontWeight: FontWeight.w500));
    });
    test('Title for light background', () {
      expect(
          MyTextStyles.titleStyleDark,
          TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: MyColors.black));
    });
    test('Title with company color', () {
      expect(
          MyTextStyles.titleStylePrimary,
          TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: MyColors.primaryColor));
    });
  });
}
