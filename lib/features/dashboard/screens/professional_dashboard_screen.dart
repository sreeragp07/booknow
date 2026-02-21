import 'package:booknow/features/auth/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfessionalDashboard extends StatelessWidget {
  const ProfessionalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        title: const Text("Professional Dashboard"),
        backgroundColor: const Color(0xFFECFDF5),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// Availability switch
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('professionals')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;

              final isOnline = data['availabilityStatus'] ?? false;

              return SwitchListTile(
                title: const Text("Available"),
                value: isOnline,
                onChanged: (value) {
                  FirebaseFirestore.instance
                      .collection('professionals')
                      .doc(userId)
                      .update({'availabilityStatus': value});
                },
              );
            },
          ),

          /// Appointment List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('professionalId', isEqualTo: userId)
                  .where('status', isEqualTo: 'Pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Pending Appointments"));
                }

                final appointments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final doc = appointments[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final dateTime = data['dateAndTime'].toDate();

                    final formatted = DateFormat(
                      'dd MMM yyyy • hh:mm a',
                    ).format(dateTime);

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("Name : ${data['userName']}"),
                        subtitle: Text("Appointment: $formatted"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Accept
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                doc.reference.update({'status': 'Confirmed'});
                              },
                            ),

                            /// Reject
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                doc.reference.update({'status': 'Rejected'});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
