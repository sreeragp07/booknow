import 'package:bloc/bloc.dart';
import 'package:booknow/models/category.dart';
import 'package:booknow/respository/data_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this._dataServices) : super(CategoryState()) {
    on<FetchCategoriesEvent>(_fetchCategories);
  }
  Future<void> _fetchCategories(FetchCategoriesEvent event, emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await _dataServices.fetchCategories();
      emit(state.copyWith(categoryList: data));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(error: 'Something Went Wrong'));
    }
    emit(state.copyWith(isLoading: false));
  }

  final DataServices _dataServices;
}
