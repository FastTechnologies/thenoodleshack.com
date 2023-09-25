import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:get/get.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field_with_validator/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/branch_provider.dart';
import '../../../utill/app_constants.dart';

class CreateAccountScreen extends StatefulWidget {
  final String email;
  final String referalCode;

  CreateAccountScreen({@required this.email,this.referalCode});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _referTextFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  final upper = RegExp(r'(?=.*[A-Z])\w+');
  final number = RegExp(r'[0-9]');
  final lower = RegExp(r'(?=.*[a-z])\w+');
bool isChecked=false;

  @override
  void initState() {
    super.initState();


   _numberController.text=widget.email.replaceAll('+1', '');
   _referTextController.text=widget.referalCode;

    debugPrint('number --${_numberController.text}');
   // _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Center(
                      child: Container(
                        width: _width > 700 ? 700 : _width,
                        padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                        decoration: _width > 700 ? BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                        ) : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              getTranslated('create_account', context),
                              style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                            )),
                            SizedBox(height: 20),

                            // for first name section
                            Text(
                              getTranslated('first_name', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: 'first name',
                              isShowBorder: true,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for last name section
                            Text(
                              getTranslated('last_name', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                            CustomTextField(
                              hintText: 'Doe',
                              isShowBorder: true,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _numberFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ):CustomTextField(
                              hintText: 'last name',
                              isShowBorder: true,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for email section

                           Text(
                              getTranslated('email', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: 'Enter your email',
                              isShowBorder: true,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          //  Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification?

                            Text(
                              getTranslated('mobile_number', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            MaskedTextField(
                              mask:AppConstants.phone_form ,
                              controller: _numberController,
                              style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
                              keyboardType: TextInputType.number,
                              readOnly: true,

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                                ),
                                isDense: true,
                                hintText: AppConstants.phone_form_hint,
                                fillColor: Theme.of(context).cardColor,

                                hintStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_GREY_CHATEAU),
                                filled: true,


                                prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),


                              ),
                            ) ,
                // Row(children: [
                //               // Expanded(child:  IntlPhoneField(
                //               //
                //               //   decoration: InputDecoration(
                //               //       labelText: 'Phone Number',
                //               //       border:InputBorder.none,
                //               //       fillColor: ColorResources.COLOR_WHITE
                //               //       ,filled: true
                //               //   ),
                //               //   initialCountryCode: 'IN',
                //               //   onChanged: (phone) {
                //               //     print(phone.completeNumber);
                //               //     _emailController.text=phone.completeNumber;
                //               //   },
                //               // ),),
                //               Expanded(child: CustomTextField(
                //                 hintText: getTranslated('number_hint', context),
                //                 isShowBorder: true,
                //                 isReadOnly: true,
                //                 controller: _numberController,
                //                 focusNode: _numberFocus,
                //                 nextFocus: _passwordFocus,
                //                 inputType: TextInputType.phone,
                //               )),
                //             ]),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                'Refer Code (Optional)',
                                style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              CustomTextField(
                                hintText: 'referal code',
                                isShowBorder: true,
                                controller: _referTextController,
                                focusNode: _referTextFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.text,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            ],),

                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                            // for password section
                            Text(
                              getTranslated('password', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                            ),
                            SizedBox(height: 22),

                            // for confirm password section
                            Text(
                              getTranslated('confirm_password', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                              inputAction: TextInputAction.done,
                            ),

                            SizedBox(height: 22),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     authProvider.registrationErrorMessage.length > 0
                            //         ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                            //         : SizedBox.shrink(),
                            //     SizedBox(width: 8),
                            //     Expanded(
                            //       child: Text(
                            //         authProvider.registrationErrorMessage ?? "",
                            //         style: Theme.of(context).textTheme.headline2.copyWith(
                            //               fontSize: Dimensions.FONT_SIZE_SMALL,
                            //               color: Theme.of(context).primaryColor,
                            //             ),
                            //       ),
                            //     )
                            //   ],
                            // ),


                            CheckboxListTile(
                              dense: true,

                              contentPadding: EdgeInsets.zero,
                             shape:  RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10)),
                              activeColor: Theme.of(context).primaryColor,

                              controlAffinity: ListTileControlAffinity.leading,
                              value: isChecked, onChanged: (val){
                             setState(() {

                               isChecked=!isChecked;
                             });
                            },title:Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child:

                              RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: 'By creating an account, you agree to our ',
                                      style: new TextStyle(color:  Theme.of(context).primaryColor),
                                    ),
                                    new TextSpan(
                                      text: 'terms & conditions',
                                      style: new TextStyle(color:ColorResources.getHintColor(context),decoration: TextDecoration.underline,fontWeight: FontWeight.w500),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(context, Routes.getTermsRoute());

                                          //launch('http://cafescale.com/terms-and-conditions');
                                        },
                                    ),
                                    new TextSpan(
                                      text: ' and ',
                                      style: new TextStyle(color: Theme.of(context).primaryColor ),
                                    ),
                                    new TextSpan(
                                      text: 'privacy policy.',
                                      style: new TextStyle(color:ColorResources.getHintColor(context),decoration: TextDecoration.underline,fontWeight: FontWeight.w500),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(context, Routes.getPolicyRoute());
                                        // launch('http://cafescale.com/privacy-policy');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ) ,),

                            // for signup button
                            SizedBox(height: 10),
                            !authProvider.isLoading
                                ? CustomButton(
                                    btnTxt: getTranslated('signup', context),
                                    onTap: () {
                                      String _firstName = _firstNameController.text.trim();
                                      String _lastName = _lastNameController.text.trim();
                                      String _number =_numberController.text.trim();
                                      String _email = _emailController.text.trim();
                                      String _password = _passwordController.text.trim();
                                      String _confirmPassword = _confirmPasswordController.text.trim();
                                      if(Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification){
                                        if (_firstName.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                        }else if (_lastName.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                        }else if (_numberController.text.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                        }else if (_password.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_password', context), context);
                                        }else if (_password.length < 6) {
                                          showCustomSnackBar(getTranslated('password_should_be', context), context);
                                        }else if (_confirmPassword.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                                        }else if(_password != _confirmPassword) {
                                          showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                        }
                                       else  if (!number.hasMatch(_password)){
                                          showCustomSnackBar('Password should include at least one number', context);

                                        }
                                        else  if (!upper.hasMatch(_password)){
                                          showCustomSnackBar('Password should include UpperCase letter', context);

                                        }
                                        else  if (!lower.hasMatch(_password)){
                                          showCustomSnackBar('Password should include LowerCase letter', context);

                                        }
                                        else {
                                          debugPrint('-=Accept');

                                          SignUpModel signUpModel = SignUpModel(
                                            fName: _firstName,
                                            lName: _lastName,
                                            email: widget.email,
                                            password: _password,
                                            phone: AppConstants.country_code+_number.replaceAll(RegExp('[()\\-\\s]'), ''),
                                            restaurantId:AppConstants.restaurantId,
                                              referralCode: _referTextController.text,

                                          );
                                          authProvider.registration(signUpModel,context).then((status) async {
                                            if (status.isSuccess) {
                                              // await Provider.of<WishListProvider>(context, listen: false).initWishList(
                                              //   context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                              // );
                                              Navigator.pushNamedAndRemoveUntil(context,Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1
                                                  ?  Routes.getMainRoute() : Routes.getBranchListScreen(), (route) => false);
                                            }
                                          });
                                        }
                                      }else{
                                        if (_firstName.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                        }else if (_lastName.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                        }else if (_number.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                        }else if (_password.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_password', context), context);
                                        }else if (_password.length < 6) {
                                          showCustomSnackBar(getTranslated('password_should_be', context), context);
                                        }else if (_confirmPassword.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                                        }else if(_password != _confirmPassword) {
                                          showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                        }
                                        else if(isChecked ==false) {
                                          debugPrint('-=not');
                                          showCustomSnackBar('Accept terms and conditions', context);
                                        }
                                        else  if (!number.hasMatch(_password)){
                                          showCustomSnackBar('Password should include at least one number', context);

                                        }
                                        else  if (!upper.hasMatch(_password)){
                                          showCustomSnackBar('Password should include UpperCase letter', context);

                                        }
                                        else  if (!lower.hasMatch(_password)){
                                          showCustomSnackBar('Password should include LowerCase letter', context);

                                        }
                                        else {
                                          SignUpModel signUpModel = SignUpModel(
                                            fName: _firstName,
                                            lName: _lastName,
                                            email: _email,
                                            password: _password,
                                            restaurantId:AppConstants.restaurantId,
                                            referralCode: _referTextController.text,




                                            phone:  widget.email.replaceAll(RegExp('[()\\-\\s]'), '').trim(),
                                          );
                                          authProvider.registration(signUpModel,context).then((status) async {
                                            if (status.isSuccess) {
                                              // await Provider.of<WishListProvider>(context, listen: false).initWishList(
                                              //   context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                              // );
                                              // authProvider.setSignUp();

                                              Navigator.pushNamedAndRemoveUntil(context,Provider.of<SplashProvider>(context, listen: false).configModel.branches.length==1
                                                  ?  Routes.getMainRoute() : Routes.getBranchListScreen(), (route) => false);
                                            }
                                          });
                                        }
                                      }
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                  )),

                            // for already an account
                            SizedBox(height: 11),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('already_have_account', context),
                                      style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context)),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                    Text(
                                      getTranslated('login', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if(ResponsiveHelper.isDesktop(context)) FooterView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
