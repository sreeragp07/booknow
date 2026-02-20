import 'package:booknow/models/professionals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfessionalsListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProfessionalsListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  Future<List<Professional>> fetchProfessionals() async {
    List<Professional> result = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      result = snapshot.docs
          .map((doc) => Professional.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error : $e");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(backgroundColor: const Color(0xFFECFDF5) ,title: Text(categoryName)),
      body: FutureBuilder<List<Professional>>(
        future: fetchProfessionals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No professionals found"));
          }

          final professionals = snapshot.data!;

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
  }
}
