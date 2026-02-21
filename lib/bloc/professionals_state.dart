part of 'professionals_bloc.dart';

class ProfessionalsState extends Equatable {
  final List<Professional> professionalsList;
  final bool isLoading;
  final String? error;
  final String? selectedSort;

  const ProfessionalsState({
    this.professionalsList = const [],
    this.isLoading = false,
    this.error,
    this.selectedSort,
  });

  ProfessionalsState copyWith({
    List<Professional>? professionalsList,
    bool? isLoading,
    String? error,
    String? selectedSort,
  }) {
    return ProfessionalsState(
      professionalsList: professionalsList ?? this.professionalsList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedSort: selectedSort,
    );
  }

  @override
  List<Object?> get props => [professionalsList, isLoading, error, selectedSort];
}
