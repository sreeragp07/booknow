import 'package:booknow/models/professionals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataServices {
  Future<List<Professional>> fetchProfessionals({
    required String categoryId,
  }) async {
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
}
