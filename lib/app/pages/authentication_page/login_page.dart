import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'forget_password_page.dart';
import 'register_page.dart';
import '../main_page/main_page.dart';
import '../../providers/page_provider.dart';
import '../../services/authentication_service/authentication_service.dart';
import '../../widgets/authentication_widget/register_widget/register_widget.dart';
import '../../widgets/main_widget/main_widget.dart';
import '../../../common/components.dart';
import '../../../common/common.dart';
import '../../../common/data/api_public_data.dart';
import '../../../common/enums/page_name_enum.dart';
import '../../../locator.dart';
import '../main_page/home_page/terms_and_rules_page/terms_and_rules_page.dart';
import '../../../common/enums/error_enum.dart';
import '../../../common/utils/app_text.dart';
import '../../../config/assets.dart';
import '../../../config/colors.dart';
import '../../../config/styles.dart';
import '../../widgets/authentication_widget/country_code_widget/code_country.dart';

class LoginPage extends StatefulWidget {
  static const String pageName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  FocusNode mailNode = FocusNode();
  // TextEditingController phoneController = TextEditingController();
  // FocusNode phoneNode = FocusNode();

  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();

  String? otherRegisterMethod;
  bool isEmptyInputs = true;
  bool isPhoneNumber = true;
  bool isSendingData = false;

  CountryCode countryCode = CountryCode(
    code: "US",
    dialCode: "+1",
    flagUri: "${AppAssets.flags}en.png",
    name: "United States",
  );

  @override
  void initState() {
    super.initState();

    // if ((PublicData.apiConfigData?['register_method'] ?? '') == 'email') {
    isPhoneNumber = false;
    otherRegisterMethod = 'email';
    // } else {
    //   isPhoneNumber = true;
    //   otherRegisterMethod = 'phone';
    // }

    mailController.addListener(() {
      if ((mailController.text.trim().isNotEmpty) &&
          passwordController.text.trim().isNotEmpty) {
        if (isEmptyInputs) {
          isEmptyInputs = false;
          setState(() {});
        }
      } else {
        if (!isEmptyInputs) {
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });

    passwordController.addListener(() {
      if ((mailController.text.trim().isNotEmpty) &&
          passwordController.text.trim().isNotEmpty) {
        if (isEmptyInputs) {
          isEmptyInputs = false;
          setState(() {});
        }
      } else {
        if (!isEmptyInputs) {
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });
  }

  void _openPrivacyPolicy() {
    nextRoute(TermsAndRulesPage.pageName);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (re) {
        MainWidget.showExitDialog();
      },
      child: directionality(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.introBgPng,
                  width: getSize().width,
                  height: getSize().height,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: padding(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      space(getSize().height * .15),

                      // title
                      Row(
                        children: [
                          Text(appText.welcomeBack, style: style24Bold()),
                          space(0, width: 4),
                          SvgPicture.asset(AppAssets.emoji2Svg),
                        ],
                      ),

                      // desc
                      Text(
                        appText.welcomeBackDesc,
                        style: style14Regular().copyWith(color: greyA5),
                      ),
                      space(50),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (PublicData
                                  .apiConfigData?['show_google_login_button'] ??
                              false) ...{
                            socialWidget(AppAssets.googleSvg, () async {
                              try {
                                setState(() {
                                  isSendingData = true;
                                });

                                await GoogleSignIn().signOut();
                                final GoogleSignInAccount? gUser =
                                    await GoogleSignIn().signIn();

                                if (gUser == null) {
                                  // User canceled the sign-in
                                  setState(() {
                                    isSendingData = false;
                                  });
                                  return;
                                }

                                final GoogleSignInAuthentication gAuth =
                                    await gUser.authentication;

                                if (gAuth.idToken != null ||
                                    gAuth.accessToken != null) {
                                  // Call the authentication service to log in with Google
                                  bool res = await AuthenticationService.google(
                                    gUser.email,
                                    gAuth.idToken ?? gAuth.accessToken ?? '',
                                    gUser.displayName ?? '',
                                  );

                                  setState(() {
                                    isSendingData = false;
                                  });

                                  if (res) {
                                    // Delete token may fail on simulator - don't let it break login
                                    try {
                                      await FirebaseMessaging.instance
                                          .deleteToken();
                                    } catch (_) {}
                                    locator<PageProvider>().setPage(
                                      PageNames.home,
                                    );
                                    nextRoute(
                                      MainPage.pageName,
                                      isClearBackRoutes: true,
                                    );
                                  } else {
                                    showSnackBar(
                                      ErrorEnum.error,
                                      null,
                                      desc:
                                          'Login with Google failed. Please try again.',
                                    );
                                  }
                                } else {
                                  setState(() {
                                    isSendingData = false;
                                  });
                                  showSnackBar(
                                    ErrorEnum.error,
                                    null,
                                    desc:
                                        'Login with Google failed. Please try again.',
                                  );
                                }
                              } catch (e) {
                                print('Authentication service error: $e');
                                setState(() {
                                  isSendingData = false;
                                });
                                showSnackBar(
                                  ErrorEnum.error,
                                  null,
                                  desc:
                                      'An error occurred during Google Login.',
                                );
                              }
                            }),
                          },
                          if (Platform.isIOS) ...{
                            space(0, width: 16),
                            socialWidget(AppAssets.appleSvg, () async {
                              try {
                                setState(() {
                                  isSendingData = true;
                                });

                                final appleCredential =
                                    await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                    AppleIDAuthorizationScopes.email,
                                    AppleIDAuthorizationScopes.fullName,
                                  ],
                                );

                                final oauthCredential =
                                    OAuthProvider('apple.com').credential(
                                  idToken: appleCredential.identityToken,
                                  accessToken:
                                      appleCredential.authorizationCode,
                                );

                                final userCredential = await FirebaseAuth
                                    .instance
                                    .signInWithCredential(oauthCredential);

                                if (userCredential.user != null) {
                                  final firebaseUser = userCredential.user!;

                                 
                                  String? email = appleCredential.email ??
                                      firebaseUser.email;

                                  String? name;
                                  if (appleCredential.givenName != null) {
                                    name =
                                        "${appleCredential.givenName} ${appleCredential.familyName ?? ''}"
                                            .trim();
                                  } else {
                                    name = firebaseUser.displayName;
                                  }

                                  // Call the authentication service to log in with Apple
                                  bool res = await AuthenticationService.apple(
                                    email,
                                    appleCredential.userIdentifier ??
                                        firebaseUser.uid,
                                    name,
                                  );

                                  setState(() {
                                    isSendingData = false;
                                  });

                                  if (res) {
                                    try {
                                      await FirebaseMessaging.instance
                                          .deleteToken();
                                    } catch (_) {}
                                    locator<PageProvider>().setPage(
                                      PageNames.home,
                                    );
                                    nextRoute(
                                      MainPage.pageName,
                                      isClearBackRoutes: true,
                                    );
                                  } else {
                                    showSnackBar(
                                      ErrorEnum.error,
                                      null,
                                      desc:
                                          'Login with Apple failed. Please try again.',
                                    );
                                  }
                                } else {
                                  setState(() {
                                    isSendingData = false;
                                  });
                                  showSnackBar(
                                    ErrorEnum.error,
                                    null,
                                    desc:
                                        'Login with Apple failed. Please try again.',
                                  );
                                }
                              } on SignInWithAppleAuthorizationException catch (e) {
                                setState(() {
                                  isSendingData = false;
                                });
                                if (e.code != AuthorizationErrorCode.canceled) {
                                  showSnackBar(
                                    ErrorEnum.error,
                                    null,
                                    desc: 'Apple Sign-In was cancelled.',
                                  );
                                }
                              } catch (e) {
                                print('Apple Sign-In error: $e');
                                setState(() {
                                  isSendingData = false;
                                });
                                showSnackBar(
                                  ErrorEnum.error,
                                  null,
                                  desc:
                                      'An error occurred during Apple Sign-In.',
                                );
                              }
                            }),
                          },
                        ],
                      ),

                      // Other Register Method
                      // if (PublicData.apiConfigData?['showOtherRegisterMethod'] ==
                      //     '1') ...{
                      //   space(15),
                      //   Container(
                      //       decoration: BoxDecoration(
                      //           color: Colors.white, borderRadius: borderRadius()),
                      //       width: getSize().width,
                      //       height: 52,
                      //       child: Row(
                      //         children: [
                      //           // email
                      //           AuthWidget.accountTypeWidget(appText.email,
                      //               otherRegisterMethod ?? '', 'email', () {
                      //             setState(() {
                      //               otherRegisterMethod = 'email';
                      //               isPhoneNumber = false;
                      //               mailController.clear();
                      //             });
                      //           }),

                      //           // email
                      //           AuthWidget.accountTypeWidget(appText.phone,
                      //               otherRegisterMethod ?? '', 'phone', () {
                      //             setState(() {
                      //               otherRegisterMethod = 'phone';
                      //               isPhoneNumber = true;
                      //               mailController.clear();
                      //             });
                      //           }),
                      //         ],
                      //       )),
                      //   space(15),
                      // },

                      // input
                      Column(
                        children: [
                          if (isPhoneNumber) ...{
                            // phone input
                            Row(
                              children: [
                                // country code
                                GestureDetector(
                                  onTap: () async {
                                    CountryCode? newData = await RegisterWidget
                                        .showCountryDialog();

                                    if (newData != null) {
                                      countryCode = newData;
                                      setState(() {});
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: borderRadius(),
                                    ),
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: borderRadius(radius: 50),
                                      child: Image.asset(
                                        countryCode.flagUri ?? '',
                                        width: 21,
                                        height: 19,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                space(0, width: 15),

                                Expanded(
                                  child: input(
                                    mailController,
                                    mailNode,
                                    appText.phoneNumber,
                                  ),
                                ),
                              ],
                            ),
                          } else ...{
                            input(
                              mailController,
                              mailNode,
                              appText.email,
                              iconPathLeft: AppAssets.mailSvg,
                              leftIconSize: 20,
                            ),
                          },
                          space(16),
                          input(
                            passwordController,
                            passwordNode,
                            appText.password,
                            iconPathLeft: AppAssets.passwordSvg,
                            leftIconSize: 20,
                            isPassword: true,
                          ),
                        ],
                      ),

                      space(32),

                      // button
                      Center(
                        child: button(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (mailController.text.trim().isNotEmpty &&
                                passwordController.text.trim().isNotEmpty) {
                              setState(() {
                                isSendingData = true;
                              });

                              bool res = await AuthenticationService.login(
                                '${isPhoneNumber ? countryCode.dialCode!.replaceAll('+', '') : ''}${mailController.text.trim()}',
                                passwordController.text.trim(),
                              );

                              setState(() {
                                isSendingData = false;
                              });

                              if (res) {
                                await FirebaseMessaging.instance.deleteToken();

                                locator<PageProvider>().setPage(PageNames.home);
                                nextRoute(
                                  MainPage.pageName,
                                  isClearBackRoutes: true,
                                );
                              } else {
                                setState(() {
                                  isSendingData = false;
                                });
                              }
                            } else {
                              showSnackBar(
                                ErrorEnum.error,
                                null,
                                desc: 'Please fill all fields',
                              );
                            }
                          },
                          width: getSize().width,
                          height: 52,
                          text: appText.login,
                          bgColor: isEmptyInputs ? greyCF : green77(),
                          textColor: Colors.white,
                          borderColor: Colors.transparent,
                          isLoading: isSendingData,
                        ),
                      ),

                      space(16),

                      // termsPoliciesDesc
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'I agree to the ',
                            style: style14Regular().copyWith(color: grey5E),
                          ),
                          GestureDetector(
                            onTap: _openPrivacyPolicy,
                            child: Text(
                              'Privacy Policy and Terms of Service',
                              style: style14Regular().copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      space(40),

                      // haveAnAccount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appText.dontHaveAnAccount,
                            style: style16Regular(),
                          ),
                          space(0, width: 2),
                          GestureDetector(
                            onTap: () {
                              nextRoute(
                                RegisterPage.pageName,
                                isClearBackRoutes: true,
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              appText.signup,
                              style: style16Regular(),
                            ),
                          ),
                        ],
                      ),

                      space(25),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            nextRoute(ForgetPasswordPage.pageName);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            appText.forgetPassword,
                            style: style16Regular().copyWith(color: greyB2),
                          ),
                        ),
                      ),

                      space(25),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            nextRoute(MainPage.pageName);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            appText.skipLogin,
                            style: style16Regular().copyWith(color: grey3A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  socialWidget(String icon, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Center(
        child: Container(
          width: 120,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: borderRadius(radius: 16)),
          child: SvgPicture.asset(icon, width: 40),
        ),
      ),
    );
  }
}
