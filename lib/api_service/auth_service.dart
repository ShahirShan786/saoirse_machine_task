import 'dart:developer';
import 'dart:io';

import 'package:epi/data/user_model/user_data.dart';
import 'package:epi/locator/app_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final cloudinary = CloudinaryPublic('dwqid6eof', 'saoirse', cache: false);
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // 🔹 Login Function
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {

      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Fetch user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        return "User data not found in Firestore.";
      }

      // Convert Firestore data to UserData model and save to local DB
      final userData = _mapFirestoreToUserData(userDoc.data()!);
      appDB.user = userData;
      appDB.isLogin = true;

      //Successful login
      return "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "No user found for that email.";
        case 'wrong-password':
          return "Incorrect password.";
        case 'invalid-email':
          return "Invalid email address.";
        default:
          return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

// Helper function to map Firestore data to UserData model
  UserData _mapFirestoreToUserData(Map<String, dynamic> firestoreData) {
    return UserData(
      id: firestoreData['uid'],
      name: firestoreData['name'],
      email: firestoreData['email'],
      phoneNumber: firestoreData['phone'],
      profilePicture: firestoreData['profileImage'],
      referralCode: firestoreData['referralCode'],
      firebaseUid: firestoreData['uid'],
      isActive: true,
      createdAt: (firestoreData['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (firestoreData['updatedAt'] as Timestamp?)?.toDate(),
    
    );
  }

// Sign Up Function
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? referralCode,
    File? profileImage,
  }) async {
    try {
     
      String? imageUrl;
      if (profileImage != null) {
        try {
          final response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              profileImage.path,
              folder: 'user_profiles',
            ),
          );
          imageUrl = response.secureUrl;
          log("Image uploaded successfully: $imageUrl"); 
        } catch (e) {
          log("Image upload failed: $e"); 
         
        }
      }

  
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final now = DateTime.now();

     
      final userData = {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone ?? '',
        'profileImage': imageUrl ?? '',
        'referralCode': referralCode ?? '',
        'createdAt':
            Timestamp.fromDate(now), 
        'updatedAt': Timestamp.fromDate(now),
      };

      // Saving the user data to Firestore
      await _firestore.collection('users').doc(uid).set(userData);


      final userDataModel = UserData(
        id: uid,
        firebaseUid: uid,
        name: name,
        email: email,
        phoneNumber: phone,
        profilePicture: imageUrl, 
        referralCode: referralCode,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      log("Saving to appDB - Profile Picture: ${userDataModel.profilePicture}"); 

      appDB.user = userDataModel;
      appDB.isLogin = true;

      return "success";
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.message}");
      return e.message;
    } catch (e) {
      log("Sign up error: $e"); 
      return e.toString();
    }
  }

// Sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return "Google Sign-In cancelled by user";

      
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

     
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

  
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return "Failed to retrieve user information from Google.";
      }

    
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
       
        final userData = _mapFirestoreToUserData(userDoc.data()!);
        appDB.user = userData;
        appDB.isLogin = true;

        log("Google Sign-In: Existing user logged in successfully.");
        return "success";
      } else {
        
        final now = DateTime.now();

        final userData = {
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone': user.phoneNumber ?? '',
          'profileImage': user.photoURL ?? '',
          'referralCode': '', 
          'createdAt': Timestamp.fromDate(now),
          'updatedAt': Timestamp.fromDate(now),
        };

        await _firestore.collection('users').doc(user.uid).set(userData);

        // Saving to local DB
        final userDataModel = UserData(
          id: user.uid,
          firebaseUid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          profilePicture: user.photoURL ?? '',
          referralCode: '',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        );

        appDB.user = userDataModel;
        appDB.isLogin = true;

        log("Google Sign-In: New user created successfully.");
        return "success";
      }
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error (Google Sign-In): ${e.message}");
      return e.message ?? "Google Sign-In failed. Please try again.";
    } catch (e) {
      log("Google Sign-In Error: $e");
      return e.toString();
    }
  }

// Logout Function
  Future<String?> logout() async {
    try {
    
      await _auth.signOut();

      
      await googleSignIn.signOut();

      
      appDB.user = UserData(
        id: '',
        firebaseUid: '',
        name: '',
        email: '',
        phoneNumber: null,
        profilePicture: null,
        referralCode: null,
        isActive: false,
      );

     
      appDB.isLogin = false;

     

      log("User logged out successfully");

      return "success";
    } on FirebaseAuthException catch (e) {
      log("Firebase logout error: ${e.message}");
      return e.message;
    } catch (e) {
      log("Logout error: $e");
      return e.toString();
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      
      if (email.isEmpty) {
        return "Please enter your email address.";
      }

      // Send reset link
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "The email address format is invalid.";
        case "user-not-found":
          return "No account found with this email.";
        case "missing-email":
          return "Please enter your email address.";
        case "too-many-requests":
          return "Too many requests. Please try again later.";
        case "network-request-failed":
          return "Network error. Please check your connection.";
        default:
          return "Something went wrong. (${e.message})";
      }
    } catch (e) {
  
      return "An unexpected error occurred. Please try again.";
    }
  }
}



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
   
      final googleUser = await _googleSignIn.signIn();

 
      if (googleUser == null) return null;

      // Retrieve the authentication details from the Google account.
      final googleAuth = await googleUser.authentication;

      // Create a new credential using the Google authentication details.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential.
      final userCredential = await _auth.signInWithCredential(credential);
      // Return the authenticated user.
      return userCredential.user;
    } catch (e) {
      log("Google Sign-In error: $e");
      debugPrint("error : $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
