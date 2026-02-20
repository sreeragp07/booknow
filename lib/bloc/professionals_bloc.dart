import 'package:bloc/bloc.dart';
import 'package:booknow/models/professionals.dart';
import 'package:booknow/respository/data_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'professionals_event.dart';
part 'professionals_state.dart';

class ProfessionalsBloc extends Bloc<ProfessionalsEvent, ProfessionalsState> {
  ProfessionalsBloc(this._dataServices) : super(ProfessionalsState()) {
    on<ProfessionalsEvent>((event, emit) {});
    on<FetchProfessionalsEvent>(_fetchProfessionals);
  }

  final DataServices _dataServices;

  Future<void> _fetchProfessionals(FetchProfessionalsEvent event, emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<Professional> result = await _dataServices.fetchProfessionals(
        categoryId: event.categoryId,
      );
      emit(state.copyWith(professionalsList: result));
    } catch (e) {
      debugPrint("Error : $e");
      emit(state.copyWith(error: "No Data Found"));
    }
    emit(state.copyWith(isLoading: false));
  }
}
