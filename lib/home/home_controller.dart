import 'dart:developer';

import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login_payment/home/home_screen.dart';
import 'package:social_login_payment/user/user_information.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class HomeController extends GetxController {
  //GOOGLE
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? googleSignInAccount;

  Future<void> handleGoogleSignIn() async {
    try {
      googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        Get.to(() => UserDetailsScreen(), arguments: {
          "displayName": googleSignInAccount?.displayName ?? "",
          "email": googleSignInAccount?.email ?? "",
          "id": googleSignInAccount?.id ?? "",
          "type": "google",
        });
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> handleGoogleSignOut() => _googleSignIn.signOut();

  //FACEBOOK
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  bool isLogged = false;
  RxBool isLoading = false.obs;
  Map<String, dynamic> userData = {};

  Future<void> faceBooklogin() async {
    isLoading.value = true;
    final LoginResult result = await facebookAuth.login();

    isLogged = result.status == LoginStatus.success;
    if (isLogged) {
      userData = await facebookAuth.getUserData();
      Get.to(() => UserDetailsScreen(), arguments: {
        "displayName": userData['name'],
        "email": userData['email'],
        "id": userData['id'],
        "type": "facebook",
      });
      log(userData.toString());
    }
    isLoading.value = false;
  }

  Future<void> faceBookLogout() async {
    isLoading.value = true;
    await facebookAuth.logOut();
    Get.back();
    isLoading.value = false;
    isLogged = false;
  }

  //LINKDIN
  UserObject? user;
  RxBool linkdlnlogoutUser = false.obs;
  String linkdlnClientId = "7887o876x2471t";
  String linkdlnRedirectUrl = "https://social-login/linkdin-login";
  String linkdlnClientSecret = "5TRyhO9LbogXV3n0";

  //TWITTER
  String apikey = "gLXZ6XxR26Zi7xWXLCE5oV1Vk";
  String twitterRedirectUrl = "https://social-login/twitter-login";
  String apiSecretKey = "fn8P7jQH98nuLU6U1p4PnMn1AqYbHdcod3iePdmLdG06lpYjrS";

  Future<void> twitterLogin() async {
    TwitterLogin twitterLogin = TwitterLogin(
      apiKey: apikey,
      apiSecretKey: apiSecretKey,
      redirectURI: twitterRedirectUrl,
    );
    AuthResult authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        log(authResult.user?.name ?? "");
        log(authResult.user?.screenName ?? "");
        log((authResult.user?.id ?? "").toString());
        Get.to(() => UserDetailsScreen(), arguments: {
          "displayName": authResult.user?.name,
          "email": authResult.user?.screenName,
          "id": authResult.user?.id ?? "",
          "type": "twitter",
        });
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        break;
      case TwitterLoginStatus.error:
        // error
        break;
      default:
    }
  }

  //GITHUB
  String gitHubClientId = "ab0e9df9cf3fcaede941";
  String gitHubRedirectUrl = "https://social-login/github-login";
  String gitHubClientSecret = "2638dc834e568b3ed1c39c107e4a63c64cfec9b3";
  RxBool gitHublogoutUser = false.obs;
  Future<void> signInWithGitHub(context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: gitHubClientId,
        clientSecret: gitHubClientSecret,
        clearCache: gitHublogoutUser.value,
        redirectUrl: gitHubRedirectUrl);
    GitHubSignInResult result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        log(result.token ?? "");
        Get.to(() => UserDetailsScreen(), arguments: {
          "displayName": result.token,
          "email": result.token,
          "id": result.token,
          "type": "github",
        });
        break;

      case GitHubSignInResultStatus.cancelled:

      case GitHubSignInResultStatus.failed:
        log(result.errorMessage);
        break;
    }
  }

  RxString currentIconName = "?".obs;
  bool showAlert = true;
  @override
  void onInit() {
    FlutterDynamicIcon.getAlternateIconName().then((v) {
      currentIconName.value = v ?? "primary";
    });
    super.onInit();
  }
}
