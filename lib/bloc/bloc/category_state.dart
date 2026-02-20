part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<Category> categoryList;
  final bool isLoading;
  final String? error;

  const CategoryState({
    this.categoryList = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    List<Category>? categoryList,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categoryList: categoryList ?? this.categoryList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categoryList, isLoading, error];
}
