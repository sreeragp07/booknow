import 'package:booknow/features/professionals/bloc/professionals_bloc.dart';
import 'package:booknow/respository/data_services.dart';
import 'package:booknow/features/professionals/screens/professional_details_screen.dart';
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
      child: BlocSelector<ProfessionalsBloc, ProfessionalsState, String?>(
        selector: (state) => state.selectedSort,
        builder: (context, value) {
          return Scaffold(
            backgroundColor: const Color(0xFFECFDF5),
            appBar: AppBar(
              backgroundColor: const Color(0xFFECFDF5),
              title: Text(categoryName),
              actions: [
                DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: value,
                      hint: Text("Sort"),
                      underline: const SizedBox(),
                      dropdownColor: Colors.white,
                      items: const [
                        DropdownMenuItem(
                          value: "rating",
                          child: Text("Sort by Rating"),
                        ),
                        DropdownMenuItem(
                          value: "price",
                          child: Text("Sort by Price"),
                        ),
                      ],
                      selectedItemBuilder: (context) {
                        return [
                          const Text("Sort by Rating"),
                          const Text("Sort by Price"),
                        ];
                      },
                      onChanged: (value) {
                        context.read<ProfessionalsBloc>().add(
                          SortProfessionalsListEvent(selectedSort: value!),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProfessionalDetailScreen(professional: pro),
                            ),
                          );
                        },
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
