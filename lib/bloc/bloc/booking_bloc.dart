import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingState()) {
    on<BooKAppointmentEvent>(_bookAppointment);
    on<SetSelectedDateEvent>(_setSelectedDate);
    on<SetSelectedTimeEvent>(_setSelectedTime);
  }
  Future<void> _bookAppointment(BooKAppointmentEvent event, emit) async {
    emit(state.copyWith(isLoading: true));
    final user = FirebaseAuth.instance.currentUser;
    final bookingDateTime = DateTime(
      state.selectedDate!.year,
      state.selectedDate!.month,
      state.selectedDate!.day,
      state.selectedTime!.hour,
      state.selectedTime!.minute,
    );
    try {
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final userName = userDoc.data()?['name'] ?? "Unknown User";
        await FirebaseFirestore.instance.collection('appointments').add({
          'userId': user.uid,
          'userName': userName,
          'professionalId': event.professionalId,
          'dateAndTime': bookingDateTime,
          'status': 'Pending',
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _setSelectedDate(SetSelectedDateEvent event, emit) async {
    emit(state.copyWith(selectedDate: event.selectedDate));
  }

  Future<void> _setSelectedTime(SetSelectedTimeEvent event, emit) async {
    emit(state.copyWith(selectedTime: event.selectedTime));
  }
}
