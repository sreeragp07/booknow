part of 'professionals_bloc.dart';

class ProfessionalsEvent {}

class FetchProfessionalsEvent extends ProfessionalsEvent {
  final String categoryId;

  FetchProfessionalsEvent({required this.categoryId});
}

class SortProfessionalsListEvent extends ProfessionalsEvent {
  final String option;

  SortProfessionalsListEvent({required this.option});
}
