part of 'professionals_bloc.dart';

class ProfessionalsState extends Equatable {
  final List<Professional> professionalsList;
  final bool isLoading;
  final String? error;

  const ProfessionalsState({
    this.professionalsList = const [],
    this.isLoading = false,
    this.error,
  });

  ProfessionalsState copyWith({
    List<Professional>? professionalsList,
    bool? isLoading,
    String? error,
  }) {
    return ProfessionalsState(
      professionalsList: professionalsList ?? this.professionalsList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [professionalsList, isLoading, error];
}
