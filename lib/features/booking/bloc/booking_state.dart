// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'booking_bloc.dart';

class BookingState extends Equatable {
  final bool isLoading;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const BookingState({
    this.isLoading = false,
    this.selectedDate,
    this.selectedTime,
  });

  BookingState copyWith({
    bool? isLoading,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }

  @override
  List<Object?> get props => [isLoading, selectedDate, selectedTime];
}
