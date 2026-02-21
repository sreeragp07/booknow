part of 'professionals_bloc.dart';

class ProfessionalsState extends Equatable {
  final List<Professional> professionalsList;
  final bool isLoading;
  final String? error;
  final String? selectedSort;
  final bool reviewLoading;
  final List<Review> reviewsList;
  final String? reviewError;

  const ProfessionalsState({
    this.professionalsList = const [],
    this.isLoading = false,
    this.error,
    this.selectedSort,
    this.reviewLoading = false,
    this.reviewsList = const [],
    this.reviewError,
  });

  ProfessionalsState copyWith({
    List<Professional>? professionalsList,
    bool? isLoading,
    String? error,
    String? selectedSort,
    bool? reviewLoading,
    List<Review>? reviewsList,
    String? reviewError,
  }) {
    return ProfessionalsState(
      professionalsList: professionalsList ?? this.professionalsList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedSort: selectedSort,
      reviewLoading: reviewLoading ?? this.reviewLoading,
      reviewsList: reviewsList ?? this.reviewsList,
      reviewError: reviewError,
    );
  }

  @override
  List<Object?> get props => [
    professionalsList,
    isLoading,
    error,
    selectedSort,
    reviewLoading,
    reviewsList,
    reviewError,
  ];
}
