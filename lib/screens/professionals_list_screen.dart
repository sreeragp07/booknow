import 'package:booknow/bloc/professionals_bloc.dart';
import 'package:booknow/respository/data_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalsListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProfessionalsListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    DataServices dataServices = DataServices();
    return BlocProvider(
      create: (context) =>
          ProfessionalsBloc(dataServices)
            ..add(FetchProfessionalsEvent(categoryId: categoryId)),
      child: BlocBuilder<ProfessionalsBloc, ProfessionalsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFECFDF5),
            appBar: AppBar(
              backgroundColor: const Color(0xFFECFDF5),
              title: Text(categoryName),
            ),
            body: BlocBuilder<ProfessionalsBloc, ProfessionalsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(child: Text(state.error ?? ''));
                }
                if (state.professionalsList.isEmpty) {
                  return Center(child: Text('No Data Found'));
                }
                final professionals = state.professionalsList;
                return ListView.builder(
                  itemCount: professionals.length,
                  itemBuilder: (context, index) {
                    final pro = professionals[index];

                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        title: Text(pro.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Experience: ${pro.experience} years"),
                            Text("Rating: ⭐ ${pro.rating}"),
                            Text("Price: ₹${pro.pricePerHour}/hr"),
                          ],
                        ),
                        trailing: Text(
                          pro.availabilityStatus == true ? "Online" : "Offline",
                          style: TextStyle(
                            color: pro.availabilityStatus == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
