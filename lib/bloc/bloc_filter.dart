import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/models/photo.dart';
import '../../../models/rover.dart';
import '../../../nasa.dart';


class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final Rover rover;
  FilterBloc({required this.rover}) : super(ResponseLoading()) {
    on<FilterEvent>((event, emit) async {
      if (event is AddFilter) {
        try {
          emit(ResponseLoading());
          var res = await NasaHelper.fetchRover(
              rover: rover,
              sol: event.sol,
              camera: event.camera.toString().split('.').last);
          emit(FilterResult(res.photos));
        } on Exception catch (e) {
          emit(FilterError(e.toString()));
        }
      }
      // emit(FilterError('No state'));
    });
  }
}

@immutable
abstract class FilterEvent {}

class AddFilter extends FilterEvent{
  final Camera camera;
  final int sol;

  AddFilter(this.camera, this.sol);
}



abstract class FilterState {}
class ResponseLoading extends FilterState {}

class FilterError extends FilterState {
  final String message;

  FilterError(this.message);
}

class FilterResult extends FilterState {
  final Iterable<Photo> photos;

  FilterResult(this.photos);
}