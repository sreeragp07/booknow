import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});
  Future<void> duplicateProfessional(String oldDocId) async {
    try {
      final oldDoc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(oldDocId)
          .get();

      final data = oldDoc.data();

      await FirebaseFirestore.instance
          .collection('professionals')
          .add(data!)
          .then((onValue) {
            debugPrint("++++++++++++++++++++++++ Added +++++++++++++++++++");
          });
    } catch (e) {
      debugPrint("???????????????????");
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            debugPrint(">>>>>>>>>>>>>>>>>");
            await duplicateProfessional('gGJmxVBSUV2AevEM4uYI');
          },
          child: Text("add"),
        ),
      ),
    );
  }
}
