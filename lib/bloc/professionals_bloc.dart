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
    on<SortProfessionalsListEvent>(_sortProfessionals);
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
      emit(state.copyWith(error: "Something Went Wrong"));
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _sortProfessionals(
    SortProfessionalsListEvent event,
    emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final List<Professional> list = List.from(state.professionalsList);
    if (event.selectedSort == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      list.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
    }

    emit(
      state.copyWith(
        professionalsList: list,
        isLoading: false,
        selectedSort: event.selectedSort,
      ),
    );
  }
}
