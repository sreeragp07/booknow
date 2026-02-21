part of 'booking_bloc.dart';

class BookingEvent {}

class SetSelectedDateEvent extends BookingEvent {
  final DateTime selectedDate;

  SetSelectedDateEvent({required this.selectedDate});
}

class SetSelectedTimeEvent extends BookingEvent {
  final TimeOfDay selectedTime;

  SetSelectedTimeEvent({required this.selectedTime});
}

class BooKAppointmentEvent extends BookingEvent {
  final String professionalId;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  BooKAppointmentEvent({
    required this.professionalId,
    required this.selectedDate,
    required this.selectedTime,
  });
}
