import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:get/get.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:social_login_payment/home/home_controller.dart';
import 'package:social_login_payment/payment/payment_screen.dart';
import 'package:social_login_payment/user/user_information.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController _con = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social Login"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          //GOOGLE LOGIN
          ElevatedButton(
            onPressed: () async => await _con.handleGoogleSignIn(),
            child: const Text("Google Login"),
          ),
          const SizedBox(height: 10),

          //FACEBOOK LOGIN
          ElevatedButton(
            onPressed: () async => await _con.faceBooklogin(),
            child: const Text("Facebook Login"),
          ),
          const SizedBox(height: 10),

          //LINKDIN LOGIN
          ElevatedButton(
            onPressed: () {
              Get.to(
                () => LinkedInUserWidget(
                  appBar: AppBar(title: const Text('Linkdin')),
                  destroySession: _con.linkedlnlogoutUser.value,
                  redirectUrl: _con.linkedlnRedirectUrl,
                  clientId: _con.linkedlnClientId,
                  clientSecret: _con.linkedlnClientSecret,
                  projection: const [
                    ProjectionParameters.id,
                    ProjectionParameters.localizedFirstName,
                    ProjectionParameters.localizedLastName,
                    ProjectionParameters.firstName,
                    ProjectionParameters.lastName,
                    ProjectionParameters.profilePicture,
                  ],
                  onError: (final UserFailedAction e) =>
                      log('Error: ${e.toString()}'),
                  onGetUserProfile: (final UserSucceededAction linkedInUser) {
                    log('Access token ${linkedInUser.user.token.accessToken}');
                    log('User id: ${linkedInUser.user.userId}');
                    _con.user = UserObject(
                      firstName: linkedInUser.user.firstName?.localized?.label,
                      lastName: linkedInUser.user.lastName?.localized?.label,
                      id: linkedInUser.user.userId,
                      email: linkedInUser
                          .user.email?.elements?[0].handleDeep?.emailAddress,
                    );
                    Get.off(() => UserDetailsScreen(), arguments: {
                      "displayName":
                          "${_con.user?.firstName} ${_con.user?.lastName}",
                      "email": _con.user?.email,
                      "id": _con.user?.id,
                      "type": "linkdin",
                    });
                  },
                ),
                fullscreenDialog: true,
              );
            },
            child: const Text("Linkdin Login"),
          ),
          const SizedBox(height: 10),

          //TWITTER LOGIN
          ElevatedButton(
            onPressed: () async => await _con.twitterLogin(),
            child: const Text("Twitter Login"),
          ),
          const SizedBox(height: 10),

          //GITHUB LOGIN
          ElevatedButton(
            onPressed: () async => await _con.signInWithGitHub(context),
            child: const Text("Github Login"),
          ),
          const SizedBox(height: 10),

          //PAYMENT MODULE
          ElevatedButton(
            onPressed: () => Get.to(() => PaymentScreen()),
            child: const Text("Payment"),
          ),
          const SizedBox(height: 10),

          //SIGNIN WITH APPLE
          SignInWithAppleButton(
            onPressed: () async {
              try {
                AuthorizationCredentialAppleID credential =
                    await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                  webAuthenticationOptions: WebAuthenticationOptions(
                    clientId:
                        'de.lunaone.flutter.signinwithappleexample.service',
                    redirectUri: Uri.parse(
                      'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                    ),
                  ),
                );
                // Store name for posterity
                if (credential.givenName != null ||
                    credential.familyName != null) {
                  final String displayName =
                      '${credential.givenName ?? ''} ${credential.familyName ?? ''}';
                  print(displayName);
                  // final prefs = await SharedPreferences.getInstance();
                  // prefs.setString('apple-name', displayName);
                }

                final oauthCredential = OAuthProvider("apple.com").credential(
                  idToken: credential.identityToken,
                );

                print(oauthCredential);
              } on SignInWithAppleException catch (e) {
                log(e.toString());
              }
            },
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => Text(
                "Current Icon Name: ${_con.currentIconName.value}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.ac_unit),
            label: const Text("Team Fortress"),
            onPressed: () async {
              try {
                if (await FlutterDynamicIcon.supportsAlternateIcons) {
                  await FlutterDynamicIcon.setAlternateIconName("teamfortress",
                      showAlert: _con.showAlert);
                  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
                  ScaffoldMessenger.of(Get.context!)
                      .showSnackBar(const SnackBar(
                    content: Text("App icon change successful"),
                  ));
                  FlutterDynamicIcon.getAlternateIconName().then((v) {
                    _con.currentIconName.value = v ?? "primary";
                  });
                  return;
                }
              } catch (e) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Failed to change app icon"),
                ));
              }
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.ac_unit),
            label: const Text("Photos"),
            onPressed: () async {
              try {
                if (await FlutterDynamicIcon.supportsAlternateIcons) {
                  await FlutterDynamicIcon.setAlternateIconName("photos",
                      showAlert: _con.showAlert);
                  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
                  ScaffoldMessenger.of(Get.context!)
                      .showSnackBar(const SnackBar(
                    content: Text("App icon change successful"),
                  ));
                  FlutterDynamicIcon.getAlternateIconName().then((v) {
                    _con.currentIconName.value = v ?? "primary";
                  });
                  return;
                }
              } catch (e) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Failed to change app icon"),
                ));
              }
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.ac_unit),
            label: const Text("Chills"),
            onPressed: () async {
              try {
                if (await FlutterDynamicIcon.supportsAlternateIcons) {
                  await FlutterDynamicIcon.setAlternateIconName("chills",
                      showAlert: _con.showAlert);
                  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
                  ScaffoldMessenger.of(Get.context!)
                      .showSnackBar(const SnackBar(
                    content: Text("App icon change successful"),
                  ));
                  FlutterDynamicIcon.getAlternateIconName().then((v) {
                    _con.currentIconName.value = v ?? "primary";
                  });
                  return;
                }
              } catch (e) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Failed to change app icon"),
                ));
              }
            },
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.restore_outlined),
            label: const Text("Restore Icon"),
            onPressed: () async {
              try {
                if (await FlutterDynamicIcon.supportsAlternateIcons) {
                  await FlutterDynamicIcon.setAlternateIconName(null,
                      showAlert: _con.showAlert);
                  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
                  ScaffoldMessenger.of(Get.context!)
                      .showSnackBar(const SnackBar(
                    content: Text("App icon restore successful"),
                  ));
                  FlutterDynamicIcon.getAlternateIconName().then((v) {
                    _con.currentIconName.value = v ?? "primary";
                  });
                  return;
                }
              } catch (e) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Failed to change app icon"),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}

class AuthCodeObject {
  AuthCodeObject({this.code, this.state});
  final String? code;
  final String? state;
}

class UserObject {
  UserObject({
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? id;
}
