import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTableProfileDialog extends StatelessWidget {
  const MyTableProfileDialog(this.model, {super.key});
  final MyUserModel model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        width: 750,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 750,
              padding: EdgeInsets.symmetric(
                  vertical: 48.0,
                  horizontal: context.width > 750 ? 96.0 : 24.0),
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColorHelper.white),
                  color: MyColorHelper.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Column(
                children: [
                  const SizedBox(height: 75.0),
                  Text(
                    model.fullName ?? 'Null',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  Text(model.email ?? 'Null'),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Phone: ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        model.phone ?? 'Null',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User Type: ',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          model.userType!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                  const SizedBox(height: 48.0),
                  MyButtonHelper.simpleButton(
                      borderColor: MyColorHelper.red1,
                      buttonColor: MyColorHelper.red1,
                      buttonText: 'Close',
                      onTap: () => Get.back())
                ],
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: MyColorHelper.white),
                  color: MyColorHelper.white.withOpacity(0.95),
                  image: model.profilePicUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            model.profilePicUrl!,
                          ))
                      : const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/default-profile.png',
                          )),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 2),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
