import 'dart:async';

import 'package:app/helper/snackbars.dart';
import 'package:app/media/view/dashboard/screen.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyMediaAuthController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  final isLoading = false.obs,
      formType = 0.obs,
      verifyEmail = false.obs,
      error = Rx<String?>(null);

  void registerUser(MyUserModel model) async {
    MyUserModel? userModel;
    try {
      error.value = null;
      isLoading.value = true;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email!, password: model.password!)
          .then((value) async {
        userModel = MyUserModel(
          id: value.user!.uid,
          email: model.email,
          password: model.password,
          fullName: model.fullName,
          phone: model.phone,
          mediaOutletName: model.mediaOutletName,
          userType: MyUserType.mediaMember,
          followings: [],
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set(userModel!.toMap());
        user = value.user;
      });
    } on FirebaseAuthException catch (e) {
      error.value = e.code;
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
    }
    finalCheck(userModel: userModel);
  }

  void loginUser(MyUserModel model) async {
    try {
      error.value = null;
      isLoading.value = true;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: model.email!, password: model.password!)
          .then((value) => user = value.user);
    } on FirebaseAuthException catch (e) {
      error.value = e.code;
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
    }
    finalCheck();
  }

  void finalCheck({MyUserModel? userModel}) async {
    print('object');
    try {
      if (user != null && error.value == null) {
        if (userModel == null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get()
              .then((value) => userModel =
                  MyUserModel.fromMap(value.data() as Map<String, dynamic>));
        }

        if (userModel != null) {
          if (userModel!.userType != MyUserType.mediaMember) {
            await FirebaseAuth.instance.signOut();
            isLoading.value = false;
            verifyEmail.value = true;
            error.value =
                'Invalid User - Only Media Members can access this App.';
            return;
          }

          if (user!.emailVerified) {
            Get.offAll(() => MyMediaDashboardScreen(currentUser: userModel!));
          } else {
            isLoading.value = false;
            verifyEmail.value = true;
            error.value = 'A verification email has been sent to your email, '
                'please click on the link to verify your email address.';
            await user!.sendEmailVerification();
            Timer.periodic(2.seconds, (timer) async {
              if (user != null) {
                await user!.reload();
                user = FirebaseAuth.instance.currentUser!;
                if (user!.emailVerified) {
                  timer.cancel();
                  Get.offAll(
                      () => MyMediaDashboardScreen(currentUser: userModel!));
                }
              } else {
                timer.cancel();
              }
            });
          }
        }
      } else {
        isLoading.value = false;
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      MySnackBarsHelper.showError(e.code);
    } catch (e) {
      isLoading.value = false;
      MySnackBarsHelper.showError('Error: ${e.toString()}');
    }
  }

  void passwordRecovery(String email) async {
    try {
      error.value = null;
      isLoading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      MySnackBarsHelper.showMessage(
          'Recovery email has been sent to your email.');
      formType.value = 0;
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      error.value = e.code;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Error: ${e.toString()}';
    }
    finalCheck();
  }
}
