
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/apps/gallery/bloc/state.dart';
import '../../../models/rover.dart';
import '../../../nasa.dart';
import 'event.dart';

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