import 'package:booknow/bloc/professionals_bloc.dart';
import 'package:booknow/models/professionals.dart';
import 'package:booknow/respository/data_services.dart';
import 'package:booknow/screens/booking_screen.dart';
import 'package:booknow/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalDetailScreen extends StatelessWidget {
  final Professional professional;

  const ProfessionalDetailScreen({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    DataServices dataServices = DataServices();
    return BlocProvider(
      create: (context) =>
          ProfessionalsBloc(dataServices)
            ..add(FetchReviewsEvent(professionalId: professional.id)),
      child: Scaffold(
        backgroundColor: const Color(0xFFECFDF5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFECFDF5),
          title: Text("Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professional.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Experience: ${professional.experience} years"),
                      Text("Rating: ⭐ ${professional.rating}"),
                      Text("Price: ₹${professional.pricePerHour}/hr"),
                      const SizedBox(height: 8),
                      Text(
                        professional.availabilityStatus ? "Online" : "Offline",
                        style: TextStyle(
                          color: professional.availabilityStatus
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// Reviews List
              Expanded(
                child: BlocBuilder<ProfessionalsBloc, ProfessionalsState>(
                  builder: (context, state) {
                    if (state.reviewLoading == true) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.reviewError != null) {
                      return Center(child: Text(state.reviewError!));
                    }

                    final reviews = state.reviewsList;

                    if (reviews.isEmpty) {
                      return Center(child: Text('No reviews yet'));
                    }

                    return ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];

                        return Card(
                          child: ListTile(
                            title: Text("⭐ ${review.rating}"),
                            subtitle: Text(review.comment),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              /// Book Appointment Button
              SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  label: "Book Appointment",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          professionalId: professional.id,
                          professionalName: professional.name,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
