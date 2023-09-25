import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../utill/app_constants.dart';

class VerificationScreen extends StatefulWidget {
  final String emailAddress;
  final bool fromSignUp;
  VerificationScreen({@required this.emailAddress, this.fromSignUp = false});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer _timer;
  int _start = 60;
  void startTimer() {
    _start = 60;
    print('--call');


    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(context: context,
        title: Provider.of<SplashProvider>(context).configModel.phoneVerification
            ? getTranslated('verify_phone', context) : getTranslated('verify_email', context),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 55),
                      Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                      Image.asset(
                        Images.email_with_background,
                        width: 142,
                        height: 142,
                      ):Icon(Icons.phone_android_outlined,size: 50,color: Theme.of(context).primaryColor,),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          '${getTranslated('please_enter_4_digit_code', context)}\n ${widget.emailAddress.replaceAll('+1', '')}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                        child: Container(
                          width: 400,
                          child: PinCodeTextField(
                            length: 4,
                            appContext: context,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 63,
                              fieldWidth: 55,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: ColorResources.colorMap[200],
                              selectedFillColor: Colors.white,
                              inactiveFillColor: ColorResources.getSearchBg(context),
                              inactiveColor: ColorResources.colorMap[200],
                              activeColor: ColorResources.colorMap[400],
                              activeFillColor: ColorResources.getSearchBg(context),
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            onChanged: authProvider.updateVerificationCode,
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                            _start!=0? 'If you did\'t receive the code in $_start seconds':'I did\'t receive the code',
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              color: ColorResources.getGreyBunkerColor(context),
                            ),
                      )),
                      Center(
                        child: InkWell(
                          onTap: () {

                            if(_start!=0){

                            }else{
                              if(widget.fromSignUp) {
                                Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                                Provider.of<AuthProvider>(context, listen: false).checkEmail(widget.emailAddress).then((value) {
                                  if (value.isSuccess) {
                                    startTimer();

                                    showCustomSnackBar('Resent code successful', context, isError: false);

                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                }):Provider.of<AuthProvider>(context, listen: false).checkPhone(widget.emailAddress.replaceAll(RegExp('[()\\-\\s]'), '')).then((value) {
                                  if (value.isSuccess) {
                                    startTimer();

                                    showCustomSnackBar('Resent code successful', context, isError: false);

                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });
                              }else {
                                Provider.of<AuthProvider>(context, listen: false).forgetPassword(widget.emailAddress).then((value) {
                                  if (value.isSuccess) {
                                    startTimer();

                                    showCustomSnackBar('Resent code successful', context, isError: false);
                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });
                              }
                            }

                          },
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              getTranslated('resend_code', context),
                              style: Theme.of(context).textTheme.headline3.copyWith(
                                    color:_start!=0?Colors.grey: ColorResources.getGreyBunkerColor(context),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      authProvider.isEnableVerificationCode ? !authProvider.isPhoneNumberVerificationButtonLoading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: CustomButton(
                                btnTxt: getTranslated('verify', context),
                                onTap: () {
                                  String _mail = Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification
                                      ? widget.emailAddress.contains('+') ? widget.emailAddress : '+'+widget.emailAddress.trim() : widget.emailAddress;
                                  print('number is : ${widget.emailAddress}');
                                  if(widget.fromSignUp) {
                                    debugPrint('--from signup ');

                                    Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                                    Provider.of<AuthProvider>(context, listen: false).verifyEmail(_mail).then((value) {
                                      if(value.isSuccess) {
                                        debugPrint('--value success ');
                                        Navigator.pushNamed(context, Routes.getCreateAccountRoute(widget.emailAddress));
                                      }else {
                                        debugPrint('--value failure ');

                                        showCustomSnackBar(value.message, context);
                                      }
                                    }):Provider.of<AuthProvider>(context, listen: false).verifyPhone(_mail).then((value) {
                                      if(value.isSuccess) {
                                        debugPrint('--value success 2 ${value.message   }   ${_mail}');
                                        debugPrint('number here is${widget.emailAddress}   ${_mail}');

                                        Navigator.pushNamed(context, Routes.getCreateAccountRoute(_mail));
                                      }else {
                                        debugPrint('--value failure 2 ');

                                        showCustomSnackBar(value.message, context);
                                      }
                                    });
                                  }else {
                                    print('mail num is : $_mail');

                                    Provider.of<AuthProvider>(context, listen: false).verifyToken(_mail).then((value) {
                                      if(value.isSuccess) {
                                        Navigator.pushNamed(context, Routes.getNewPassRoute(_mail, authProvider.verificationCode));
                                      }else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    });
                                  }
                                },
                              ),
                            ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
