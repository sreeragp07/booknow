part of 'professionals_bloc.dart';

class ProfessionalsEvent {}

class FetchProfessionalsEvent extends ProfessionalsEvent {
  final String categoryId;

  FetchProfessionalsEvent({required this.categoryId});
}

class SortProfessionalsListEvent extends ProfessionalsEvent {
  final String selectedSort;

  SortProfessionalsListEvent({required this.selectedSort});
}
