import 'package:booknow/features/booking/bloc/booking_bloc.dart';
import 'package:booknow/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingScreen extends StatefulWidget {
  final String professionalId;
  final String professionalName;

  const BookingScreen({
    super.key,
    required this.professionalId,
    required this.professionalName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFECFDF5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFECFDF5),
          title: const Text("Book Appointment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                widget.professionalName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// Select Date
              BlocSelector<BookingBloc, BookingState, DateTime?>(
                selector: (state) {
                  return state.selectedDate;
                },
                builder: (context, selectedDate) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );

                        if (date != null) {
                          context.read<BookingBloc>().add(
                            SetSelectedDateEvent(selectedDate: date),
                          );
                        }
                      },
                      child: Text(
                        selectedDate == null
                            ? "Select Date"
                            : selectedDate.toString().split(" ")[0],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// Select Time
              BlocSelector<BookingBloc, BookingState, TimeOfDay?>(
                selector: (state) {
                  return state.selectedTime;
                },
                builder: (context, selectedTime) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time != null) {
                          context.read<BookingBloc>().add(
                            SetSelectedTimeEvent(selectedTime: time),
                          );
                        }
                      },
                      child: Text(
                        selectedTime == null
                            ? "Select Time"
                            : selectedTime.format(context),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              /// Confirm Button
              BlocSelector<
                BookingBloc,
                BookingState,
                (DateTime?, TimeOfDay?, bool)
              >(
                selector: (state) =>
                    (state.selectedDate, state.selectedTime, state.isLoading),
                builder: (context, data) {
                  return SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        customElevatedButton(
                          label: "Book Appointment",
                          onPressed: data.$3
                              ? null
                              : () {
                                  final date = data.$1;
                                  final time = data.$2;
                                  if (date == null || time == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Date and Time required!",
                                        ),
                                      ),
                                    );

                                    return;
                                  }
                                  context.read<BookingBloc>().add(
                                    BooKAppointmentEvent(
                                      professionalId: widget.professionalId,
                                      selectedDate: date,
                                      selectedTime: time,
                                    ),
                                  );
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Booking Requested"),
                                    ),
                                  );
                                },
                        ),
                        data.$3
                            ? CircularProgressIndicator(color: Colors.black)
                            : SizedBox.shrink(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
