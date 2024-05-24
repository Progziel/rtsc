import 'dart:typed_data';

import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyUserApis {
  String collection = 'users';
  final MyUserModel? currentUser;
  MyUserApis(this.currentUser);

  Future<String?> addNewUser(MyUserModel model, Uint8List? pic) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email!, password: model.password!)
          .then((userCredential) async {
        String? profilePicUrl;
        if (pic != null) {
          await _uploadLogo(userCredential.user!.uid, pic).then((value) =>
              profilePicUrl = value.startsWith('https://') ? value : null);
        }
        model.id = userCredential.user!.uid;
        model.companyId = currentUser!.companyId;
        model.profilePicUrl = profilePicUrl;
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(model.id)
            .set(model.toMap())
            .then((value) => FirebaseAuth.instance.signInWithEmailAndPassword(
                email: currentUser!.email!, password: currentUser!.password!));
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> updateUser(MyUserModel model, Uint8List? pic) async {
    try {
      String? profilePicUrl;
      if (pic != null) {
        await _uploadLogo(model.id!, pic).then((value) =>
            profilePicUrl = value.startsWith('https://') ? value : null);
      }
      model.profilePicUrl = profilePicUrl ?? model.profilePicUrl;
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(model.id)
          .set(model.toMap());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> _uploadLogo(String userId, Uint8List data) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('logos').child(userId);
      await ref.putData(data, SettableMetadata(contentType: 'image/png'));
      String url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> removeUser(MyUserModel model) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: model.email!, password: model.password!)
          .then((userCredential) {
        userCredential.user!.delete().then((value) => FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: currentUser!.email!, password: currentUser!.password!)
            .then((value) => FirebaseFirestore.instance
                .collection(collection)
                .doc(model.id)
                .delete()));
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
