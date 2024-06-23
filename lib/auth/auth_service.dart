import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

// 1-login
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in with email and password: ${e.code}');
    }
  }
  // 2-signup
  Future<UserCredential> signup(String email,password,name)async{
    try{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //saving data to firestore
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid':userCredential.user!.uid,
            'email':email,
            'name':name,
          }
      );

      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception('Failed to sign in with email and password: ${e.code}');
    }
  }
  // 3-logout
  Future<void> logout() async{
    return await _auth.signOut();
  }
  // 4-get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }
}