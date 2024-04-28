
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
  firestore: ref.read(firestoreProvider),
  auth: ref.read(authProvider),
  googleSignIn: ref.read(googleSignInProvider),
));

class AuthRepository{
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  const AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChange => _auth.authStateChanges();
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  // CollectionReference get _owners => _firestore.collection(FirebaseConstants.petOwnerCollection);
  // CollectionReference get _caretakers => _firestore.collection(FirebaseConstants.petCareTakerCollection);

  FutureEither<UserModel> signupWithEmailAndPassword(
      {required String email, required String password}) async {
    UserModel userModel;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if(credential.additionalUserInfo!.isNewUser){

        userModel = UserModel(
          name: credential.user!.displayName??'No name',
          profilePic: credential.user!.photoURL??Constants.avatarDefault,
          uid: credential.user!.uid,
          mail: credential.user!.email,
          isAuthenticated: true,
          balance:0,
          address: '',
          type: '',
          bills: [],
          pets: [],
        );
        await  _users.doc(userModel.uid).set(userModel.toMap());
      }else {
        //IF USER EXİST
        userModel =await getUserData(credential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    print("repositoyrydeki");

    print(email+"123hi");
    UserModel userModel ;
    try {
      print('burası authentication with email kısmı');
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      print(credential.user!.email);
      userModel = await getUserData(credential.user!.uid).first;
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async  {
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth =await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken:  googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      //We create credential so that firebase authentication store google sign in data in
      //in the console

      UserCredential userCredential =await _auth.signInWithCredential(credential);
      UserModel userModel;

      if(userCredential.additionalUserInfo!.isNewUser){
        //Check the role,

        userModel = UserModel(
          name: userCredential.user!.displayName??'No name',
            profilePic: userCredential.user!.photoURL??Constants.avatarDefault,
            uid: userCredential.user!.uid,
            mail: userCredential.user!.email,
            isAuthenticated: true,
            balance:  0 ,
            address: '',
            type: '',
          bills: [],
          pets: [],
        );
        await  _users.doc(userModel.uid).set(userModel.toMap());
      }else{
        //IF THE USER EXİST
        userModel =await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    }on FirebaseException catch (e){
      throw e.message!;
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }
  Stream<UserModel> getUserData(String uid){
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }


}