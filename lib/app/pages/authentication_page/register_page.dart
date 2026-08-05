import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/register_config_model.dart';
import 'login_page.dart';
import 'verify_code_page.dart';
import '../main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import '../main_page/home_page/terms_and_rules_page/terms_and_rules_page.dart';
import '../main_page/main_page.dart';
import '../../services/authentication_service/authentication_service.dart';
import '../../services/guest_service/guest_service.dart';
import '../../widgets/authentication_widget/auth_widget.dart';
import '../../widgets/authentication_widget/country_code_widget/code_country.dart';
import '../../widgets/authentication_widget/register_widget/register_widget.dart';
import '../../widgets/main_widget/main_widget.dart';
import '../../../common/common.dart';
import '../../../common/data/api_public_data.dart';
import '../../../common/enums/error_enum.dart';
import '../../../common/utils/app_text.dart';
import '../../../common/utils/constants.dart';
import '../../../config/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/enums/page_name_enum.dart';
import '../../../config/assets.dart';
import '../../../config/colors.dart';
import '../../../common/components.dart';
import '../../../locator.dart';
import '../../providers/page_provider.dart';

class RegisterPage extends StatefulWidget {
  static const String pageName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController mailController = TextEditingController();
  FocusNode mailNode = FocusNode();
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();

  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();
  TextEditingController retypePasswordController = TextEditingController();
  FocusNode retypePasswordNode = FocusNode();

  bool isEmptyInputs = true;
  bool isPhoneNumber = true;
  bool isSendingData = false;
  bool isAgreedToTerms = false; // Add this variable

  CountryCode countryCode = CountryCode(
      code: "US",
      dialCode: "+1",
      flagUri: "${AppAssets.flags}en.png",
      name: "United States");

  // user
  // teacher
  // organization
  String accountType = 'user';
  bool isLoadingAccountType = false;

  String? otherRegisterMethod;
  RegisterConfigModel? registerConfig;

  List<dynamic> selectRolesDuringRegistration = [];

  @override
  void initState() {
    super.initState();

    isPhoneNumber = false;
    otherRegisterMethod = 'email';

    mailController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
    retypePasswordController.addListener(updateButtonState);

    getAccountTypeFileds();
  }

  void updateButtonState() {
    final hasEmailOrPhone = mailController.text.trim().isNotEmpty ||
        phoneController.text.trim().isNotEmpty;
    final hasPassword = passwordController.text.trim().isNotEmpty;
    final hasRetypePassword = retypePasswordController.text.trim().isNotEmpty;
    final allFieldsFilled = hasEmailOrPhone && hasPassword && hasRetypePassword;

    // Button should be enabled only when ALL fields are filled AND user agreed to terms
    final shouldButtonBeEnabled = allFieldsFilled && isAgreedToTerms;
    if (!mounted) return;
    if (isEmptyInputs != !shouldButtonBeEnabled) {
      if (mounted) {
        setState(() {
          isEmptyInputs = !shouldButtonBeEnabled;
        });
      }
    }
  }

  getAccountTypeFileds() async {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        isLoadingAccountType = true;
      });
    }
    registerConfig = await GuestService.registerConfig(accountType);
    if (mounted) {
      setState(() {
        isLoadingAccountType = false;
      });
    }
  }

  void _openPrivacyPolicy() {
    // Redirect to your privacy policy web page
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
            )),
            Positioned.fill(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: padding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space(getSize().height * .11),

                  // title
                  Row(
                    children: [
                      Text(
                        appText.createAccount,
                        style: style24Bold(),
                      ),
                    ],
                  ),

                  // desc
                  Text(
                    appText.createAccountDesc,
                    style: style14Regular().copyWith(color: greyA5),
                  ),

                  space(50),

                  if (registerConfig?.showGoogleLoginButton ?? false) ...{
                    socialWidget(AppAssets.googleSvg, () async {
                      try {
                        final GoogleSignInAccount? gUser =
                            await GoogleSignIn().signIn();

                        if (gUser == null) {
                          return;
                        }

                        final GoogleSignInAuthentication gAuth =
                            await gUser.authentication;

                        if (gAuth.accessToken != null) {
                          setState(() {
                            isSendingData = true;
                          });

                          try {
                            bool res = await AuthenticationService.google(
                                gUser.email,
                                gAuth.accessToken ?? '',
                                gUser.displayName ?? '');

                            if (res) {
                              await FirebaseMessaging.instance.deleteToken();
                              nextRoute(MainPage.pageName,
                                  isClearBackRoutes: true);
                            }
                          } catch (e) {
                            print('Authentication service error: $e');
                          }

                          setState(() {
                            isSendingData = false;
                          });
                        }
                      } on PlatformException catch (e) {
                        print(
                            'Google Sign-In PlatformException: ${e.code} - ${e.message}');
                      } catch (e) {
                        print('Unexpected error: $e');
                      }
                    }),
                  },
                  space(13),

                  if (isPhoneNumber) ...{
                    Row(
                      children: [
                        // country code
                        GestureDetector(
                          onTap: () async {
                            CountryCode? newData =
                                await RegisterWidget.showCountryDialog();

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
                                borderRadius: borderRadius()),
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
                            child: input(phoneController, phoneNode,
                                appText.phoneNumber))
                      ],
                    )
                  } else ...{
                    input(mailController, mailNode, appText.yourEmail,
                        iconPathLeft: AppAssets.mailSvg, leftIconSize: 20),
                  },

                  space(16),

                  input(passwordController, passwordNode, appText.password,
                      iconPathLeft: AppAssets.passwordSvg,
                      leftIconSize: 20,
                      isPassword: true),

                  space(16),

                  input(retypePasswordController, retypePasswordNode,
                      appText.retypePassword,
                      iconPathLeft: AppAssets.passwordSvg,
                      leftIconSize: 20,
                      isPassword: true),

                  isLoadingAccountType
                      ? loading()
                      : Column(
                          children: [
                            ...List.generate(
                                registerConfig?.formFields?.fields?.length ?? 0,
                                (index) {
                              return registerConfig?.formFields?.fields?[index]
                                      .getWidget() ??
                                  const SizedBox();
                            })
                          ],
                        ),

                  // Agreement Checkbox
                  space(16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isAgreedToTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              isAgreedToTerms = value ?? false;
                              updateButtonState();
                            });
                          },
                          activeColor: green77(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
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
                      ],
                    ),
                  ),

                  space(16),

                  Center(
                    child: button(
                      onTap: (isAgreedToTerms && !isEmptyInputs)
                          ? () async {
                              if (!isEmptyInputs) {
                                if (registerConfig?.formFields?.fields !=
                                    null) {
                                  for (var i = 0;
                                      i <
                                          (registerConfig?.formFields?.fields
                                                  ?.length ??
                                              0);
                                      i++) {
                                    if (registerConfig?.formFields?.fields?[i]
                                                .isRequired ==
                                            1 &&
                                        registerConfig?.formFields?.fields?[i]
                                                .userSelectedData ==
                                            null) {
                                      if (registerConfig
                                              ?.formFields?.fields?[i].type !=
                                          'toggle') {
                                        showSnackBar(ErrorEnum.alert,
                                            '${appText.pleaseReview} ${registerConfig?.formFields?.fields?[i].getTitle()}');
                                        return;
                                      }
                                    }
                                  }
                                }

                                if (passwordController.text.trim().compareTo(
                                        retypePasswordController.text.trim()) ==
                                    0) {
                                  setState(() {
                                    isSendingData = true;
                                  });

                                  if (registerConfig?.registerMethod ==
                                      'email') {
                                    Map? res = await AuthenticationService
                                        .registerWithEmail(
                                            registerConfig?.registerMethod ??
                                                '',
                                            mailController.text.trim(),
                                            passwordController.text.trim(),
                                            retypePasswordController.text
                                                .trim(),
                                            accountType,
                                            registerConfig?.formFields?.fields);

                                    if (res != null) {
                                      if (res['step'] == 'stored' ||
                                          res['step'] == 'go_step_2') {
                                        nextRoute(VerifyCodePage.pageName,
                                            arguments: {
                                              'user_id': res['user_id'],
                                              'email':
                                                  mailController.text.trim(),
                                              'password': passwordController
                                                  .text
                                                  .trim(),
                                              'retypePassword':
                                                  retypePasswordController.text
                                                      .trim(),
                                            });
                                      } else if (res['step'] == 'go_step_3') {
                                        nextRoute(MainPage.pageName,
                                            arguments: res['user_id']);
                                      }
                                    }
                                  } else {
                                    Map? res = await AuthenticationService
                                        .registerWithPhone(
                                            registerConfig?.registerMethod ??
                                                '',
                                            countryCode.dialCode.toString(),
                                            phoneController.text.trim(),
                                            passwordController.text.trim(),
                                            retypePasswordController.text
                                                .trim(),
                                            accountType,
                                            registerConfig?.formFields?.fields);

                                    if (res != null) {
                                      if (res['step'] == 'stored' ||
                                          res['step'] == 'go_step_2') {
                                        nextRoute(VerifyCodePage.pageName,
                                            arguments: {
                                              'user_id': res['user_id'],
                                              'countryCode': countryCode
                                                  .dialCode
                                                  .toString(),
                                              'phone':
                                                  phoneController.text.trim(),
                                              'password': passwordController
                                                  .text
                                                  .trim(),
                                              'retypePassword':
                                                  retypePasswordController.text
                                                      .trim()
                                            });
                                      } else if (res['step'] == 'go_step_3') {
                                        locator<PageProvider>()
                                            .setPage(PageNames.home);
                                        nextRoute(MainPage.pageName,
                                            arguments: res['user_id']);
                                      }
                                    }
                                  }

                                  setState(() {
                                    isSendingData = false;
                                  });
                                } else {
                                  // Show password mismatch error
                                  showSnackBar(ErrorEnum.alert,
                                      appText.passwordAndRetypePassNotMatch);
                                }
                              }
                            }
                          : () {
                              // Do nothing when button is disabled
                              // Or show a message why it's disabled
                              if (!isAgreedToTerms) {
                                showSnackBar(
                                    ErrorEnum.alert, "Please Agree To Terms");
                              } else if (isEmptyInputs) {
                                showSnackBar(
                                    ErrorEnum.alert, 'Please Fill All Fields');
                              }
                            },
                      width: getSize().width,
                      height: 52,
                      text: appText.createAnAccount,
                      bgColor: (isAgreedToTerms && !isEmptyInputs)
                          ? green77()
                          : greyCF,
                      textColor: Colors.white,
                      borderColor: Colors.transparent,
                      isLoading: isSendingData,
                    ),
                  ),

                  space(16),

                  // termsPoliciesDesc
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        nextRoute(WebViewPage.pageName, arguments: [
                          '${Constants.dommain}/pages/app-terms',
                          appText.webinar,
                          false,
                          LoadRequestMethod.get
                        ]);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        appText.termsPoliciesDesc,
                        style: style14Regular().copyWith(color: greyA5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  space(80),

                  // haveAnAccount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appText.haveAnAccount,
                        style: style16Regular(),
                      ),
                      space(0, width: 2),
                      GestureDetector(
                        onTap: () {
                          nextRoute(LoginPage.pageName,
                              isClearBackRoutes: true);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          appText.login,
                          style: style16Regular(),
                        ),
                      )
                    ],
                  ),

                  space(25),
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }

  Widget socialWidget(String icon, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: greyCF.withOpacity(0.5),
            borderRadius: borderRadius(radius: 16),
          ),
          child: SvgPicture.asset(
            icon,
            width: 40,
          ),
        ),
      ),
    );
  }
}
