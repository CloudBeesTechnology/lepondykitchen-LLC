import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_web/constant.dart';

class VendorFavoriteButton extends StatefulWidget {
  final bool isWhite;
  final String vendorId;

  const VendorFavoriteButton(
      {super.key, required this.vendorId, required this.isWhite});

  @override
  State<VendorFavoriteButton> createState() => _VendorFavoriteButtonState();
}

class _VendorFavoriteButtonState extends State<VendorFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: isFavorite(widget.vendorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final isFavorite = snapshot.data ?? false;

        return Container(
          height: 30,
          width: 30,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
            padding: EdgeInsets.zero,
            // iconSize: 40,
            iconSize: 20,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? appColor : Colors.black,
            onPressed: () async {
              try {
                await VendorService().toggleFavorite(widget.vendorId);
                if (context.mounted) {
                  Fluttertoast.showToast(
                      msg: isFavorite
                          ? "Removed from favorites"
                          : "Added to favorites",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 3,
                      backgroundColor:  const Color(0xFFFFD581),
                      textColor: Colors.black,
                      webBgColor: "#FFD581",
                      webPosition: "center",
                      fontSize: 14.0);
                }
              } catch (e) {
                if (context.mounted) {
                  Fluttertoast.showToast(
                      msg: "Error: ${e.toString()}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 3,
                      backgroundColor:  const Color(0xFFFFD581),
                      textColor: Colors.black,
                      webBgColor: "#FFD581",
                      webPosition: "center",
                      fontSize: 14.0);
                }
              }
            },
          ),
        );
      },
    );
  }

  Stream<bool> isFavorite(String vendorId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Return a stream that emits false and completes
      return Stream.value(false);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(vendorId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }
}

class VendorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleFavorite(String vendorId) async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not logged in");
    }

    final favoriteDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(vendorId);

    final snapshot = await favoriteDoc.get();

    if (snapshot.exists) {
      // Vendor is already a favorite, remove it
      await favoriteDoc.delete();
    } else {
      // Vendor is not a favorite, add it
      await favoriteDoc.set({'timestamp': FieldValue.serverTimestamp()});
    }
  }
}
