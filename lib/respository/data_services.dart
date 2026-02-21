import 'package:booknow/models/category.dart';
import 'package:booknow/models/professionals.dart';
import 'package:booknow/models/review.dart';
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

  Future<List<Category>> fetchCategories() async {
    List<Category> result = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();

      result = snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error : $e");
    }

    return result;
  }

  Future<List<Review>> fetchReviews({required String professionalId}) async {
    List<Review> result = [];

    try {
      final data = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(professionalId)
          .collection('reviews')
          .get();

      result = data.docs
          .map((doc) => Review.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error : $e");
    }
    return result;
  }
}
