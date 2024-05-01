
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/models/base_model.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';


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
  CollectionReference get _caretakers => _firestore.collection(FirebaseConstants.petCareTakerCollection);

  FutureEither<BaseModel> signupWithEmailAndPassword(
      {required String email, required String password,required String type}) async {
    BaseModel? baseModel;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String collectionName = _getCollectionNameByRole(type);
      //Collection name got and then search for person in each available collection
      switch (collectionName) {
        case "owner":
          if (credential.additionalUserInfo!.isNewUser) {
            baseModel = UserModel(
              name: credential.user!.displayName ?? 'No name',
              profilePic: credential.user!.photoURL ?? Constants.avatarDefault,
              uid: credential.user!.uid,
              mail: credential.user!.email,
              isAuthenticated: true,
              balance: 0,
              address: '',
              type: type,
              bills: [],
              pets: [],
            );
            await _users.doc(baseModel.uid).set(baseModel.toMap());
          }
          break;
        case "caretaker":
          if (credential.additionalUserInfo!.isNewUser) {
            baseModel = PetCareTakerModel(
              name: credential.user!.displayName ?? 'No name',
              profilePic: credential.user!.photoURL ?? Constants.avatarDefault,
              uid: credential.user!.uid,
              mail: credential.user!.email,
              isAuthenticated: true,
              balance: 0,
              address: '',
              type: type,
              bills: [],
              session: [],
            );
            await _caretakers.doc(baseModel.uid).set(baseModel.toMap());
          }
          break;
        default:
        // Handle unknown user types or logic when none of the cases match
          throw Exception("Unhandled user type: $type");
      }
      // return right(baseModel);
      return right(baseModel!);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.toString()));
    }
  }
  Stream<BaseModel>? findUserInRoleCollections(String uid)  {
    List<String> roleCollections = ['owner', 'caretaker'];  // Add all your role collections here
    for (String collection in roleCollections) {
      if(collection == 'owner'){
        return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
      }else{
        return _caretakers.doc(uid).snapshots().map((event) => PetCareTakerModel.fromMap(event.data() as Map<String, dynamic>));
      }
        }
    return null ;
  }
  FutureEither<BaseModel> signInWithEmailAndPassword(
      String email, String password,String type) async {
    BaseModel? baseModel ;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String collectionName = _getCollectionNameByRole(type);
      //Collection name got and then search for person in each available collection
      baseModel = await findUserInRoleCollections(credential.user!.uid)!.first;
      return right(baseModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<BaseModel> signInWithGoogle({required String type}) async  {
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
      BaseModel? baseModel;
      String collectionName = _getCollectionNameByRole(type);
      switch (collectionName) {
        case "owner":
          if (userCredential.additionalUserInfo!.isNewUser) {
            baseModel = UserModel(
              name: userCredential.user!.displayName ?? 'No name',
              profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
              uid: userCredential.user!.uid,
              mail: userCredential.user!.email,
              isAuthenticated: true,
              balance: 0,
              address: '',
              type: collectionName,
              bills: [],
              pets: [],
            );
            await _users.doc(baseModel.uid).set(baseModel.toMap());
          } else {
            // If user exists
            baseModel = await findUserInRoleCollections(userCredential.user!.uid)!.first;
          }
          break;
        case "caretaker":
          if (userCredential.additionalUserInfo!.isNewUser) {
            baseModel = PetCareTakerModel(
              name: userCredential.user!.displayName ?? 'No name',
              profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
              uid: userCredential.user!.uid,
              mail: userCredential.user!.email,
              isAuthenticated: true,
              balance: 0,
              address: '',
              type: collectionName,
              bills: [],
              session: [],
            );
            await _caretakers.doc(baseModel.uid).set(baseModel.toMap());
          } else {
            // If user exists
            baseModel = await findUserInRoleCollections(userCredential.user!.uid)!.first;
          }
          break;
        default:
        // Handle unknown user types or logic when none of the cases match
          throw Exception("Unhandled user type: $type");
      }
      return right(baseModel!);
    }on FirebaseException catch (e){
      throw e.message!;
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

  String _getCollectionNameByRole(String role) {
    switch (role) {
      case 'owner':
        return 'owner';
      case 'caretaker':
        return 'caretaker';
      default:
        return 'owner';
    }
  }
  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }


}