// ignore_for_file: use_key_in_widget_constructors, unnecessary_const, avoid_print, prefer_is_empty, prefer_const_constructors_in_immutables, unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'dart:math';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/utill/app_toast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../data/model/response/PaymentCardModel.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../provider/paymet_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';

class AddCard extends StatefulWidget {
  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
//   @override
// initState() {
//   super.initState();
//   StripePayment.setOptions(
//       StripeOptions(
//          publishableKey:"YOUR_PUBLISHABLE_KEY",
//           merchantId: "YOUR_MERCHANT_ID",
//           androidPayMode: 'test'
// ));
// }
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:  CustomAppBar(context: context, title: 'Add Card'),
        body: Consumer<PaymentProvider>(
            builder: (context, paymentProvider, child) {
          return SingleChildScrollView(
            child: Container(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),

                  // CreditCardWidget(
                  //   cardNumber: cardNumber,
                  //   expiryDate: expiryDate,
                  //   cardHolderName: cardHolderName,
                  //   cvvCode: cvvCode,
                  //   showBackView: isCvvFocused,
                  //   //  onChange: ( cardHolderName,  cardnumber,  cvvCode,  expiryDate) { },
                  // ),
                  CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                    onChange: (String cardnumber, String expiryDate,
                        String cardHolderName, String cvvCode) {
                      print(cardnumber + expiryDate + cardHolderName + cvvCode);
                    },
                    cardNumber: '',
                  ),
                  // AppText(text: "${data12.body}"),
                  // Spacer(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 400,
                      child: paymentProvider.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ))
                          : CustomButton(
                              btnTxt: 'Sava',
                              onTap: () async {
                                debugPrint('onTap - Submit');

                                // var strMonthAndYear =

                                debugPrint('onTap - $year');

                                if (cardNumber.isEmpty) {
                                  appToast(text: 'Enter Card number ');
                                  return;
                                }

                                if (expiryDate.isEmpty) {
                                  appToast(text: 'Enter card expiry ');

                                  return;
                                }

                                if (cvvCode.isEmpty) {
                                  appToast(
                                    text: 'enter ccv',
                                  );
                                  return;
                                }

                                if (cardHolderName.isEmpty) {
                                  appToast(
                                    text: 'enter card holder ',
                                  );

                                  return;
                                }

                                // if (strMonthAndYear.isNotEmpty) {
                                //
                                //   appSnackBar(tileText: 'Error',
                                //       descriptionText: strMonthAndYear);
                                //   return;
                                // }
                                //
                                // return;

                                // getAllPaymentCard();

                                if (validateMonthAndYear(expiryDate).isEmpty) {
                                  appToast(text: 'Something went wrong');

                                  return;
                                }
                                paymentProvider
                                    .addCard(
                                        PyamentCardModel(
                                            cardNo: cardNumber.toString(),
                                            expMonth: expiryDate
                                                .toString()
                                                .split('/')
                                                .first,
                                            expYear: expiryDate
                                                .toString()
                                                .split('/')
                                                .last,
                                            cvc: cvvCode.toString(),
                                            cardholder:
                                                cardHolderName.toString()),
                                        context)
                                    .then((value) {
                                  if (value.isSuccess) {
                                    Navigator.pop(context);
                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });

                                // paymentController.createCustomerCard(
                                //   card_holder_name: cardHolderName.toString(),
                                //   cvc: cvvCode.toString(),
                                //   card_no: cardNumber.toString(),
                                //   exp_month:
                                //       expiryDate.toString().split('/').first,
                                //   exp_year:
                                //       expiryDate.toString().split('/').last,
                                // );
                              }),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }

  var isLoading = false;

  // .... Validation for Month and Year TextInput ....
  String validateMonthAndYear(String value) {
    {
      //print('Updated $value');
      List<String> monthAndYear = value.split("/");
      // if (monthAndYear.length > 1){
      if (value.length > 0) {
        if (GetUtils.isNum(monthAndYear[0])) {
          return "Month must be in digit";
        }
        int monthValue = int.parse(monthAndYear[0]);
        if (monthValue > 12) {
          return "Invalid Month";
        }
        if (monthAndYear.length > 1) {
          String value = monthAndYear[1];
          if (value.length > 0) {
            int yearValue = int.parse(monthAndYear[1]);
            Future.delayed(
              Duration.zero,
              () => setState(
                () {
                  month = monthValue.toString();
                  year = yearValue.toString();
                },
              ),
            );

            var now = DateTime.now();
            debugPrint('yearValue $yearValue - now.year ${now.year}');

            if (yearValue < now.year) {
              debugPrint('yearValue $yearValue - now.year ${now.year}');
              return "Invalid Year";
            }
            // print(yearValue);
          }
        }
      }
    }
    return "";
  }

  // .... Validation for Numeric value ....
  String validateNumericValue(String value) {
    if (GetUtils.isNum(value)) {
      return "Card number must be in digit";
    }
    return "";
  }

  String month = "";
  String year = "";
  String tokenId = "";
  String cardBrand = "";
  String lastFour = "";
  static const platform =
      const MethodChannel('https://api.stripe.com/v1/tokens');

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    debugPrint('onCreditCardModelChange: ${creditCardModel.expiryDate}');
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

// - getTokenPaymentCard

// GetPaymentResponse? getPaymentResponse;
// var data12;
}

Map<CardType, Set<List<String>>> cardNumPatterns =
    <CardType, Set<List<String>>>{
  CardType.visa: <List<String>>{
    <String>['4'],
  },
  CardType.americanExpress: <List<String>>{
    <String>['34'],
    <String>['37'],
  },
  CardType.discover: <List<String>>{
    <String>['6011'],
    <String>['622126', '622925'],
    <String>['644', '649'],
    <String>['65']
  },
  CardType.mastercard: <List<String>>{
    <String>['51', '55'],
    <String>['2221', '2229'],
    <String>['223', '229'],
    <String>['23', '26'],
    <String>['270', '271'],
    <String>['2720'],
  },
};

CardType detectCCType(String cardNumber) {
  //Default card type is other
  CardType cardType = CardType.otherBrand;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        // Remove any spaces
        String ccPatternStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
        final int rangeLen = patternRange[0].length;
        // Trim the Credit Card number string to match the pattern prefix length
        if (rangeLen < cardNumber.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          // Convert the prefix range into numbers then make sure the
          // Credit Card num is in the pattern range.
          // Because Strings don't have '>=' type operators
          final int ccPrefixAsInt = int.parse(ccPatternStr);
          final int startPatternPrefixAsInt = int.parse(patternRange[0]);
          final int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardType = type;
            break;
          }
        } else {
          // Just compare the single pattern prefix with the Credit Card prefix
          if (ccPatternStr == patternRange[0]) {
            // Found a match
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}

// This method returns the icon for the visa card type if found
// else will return the empty container
Widget getCardTypeIcon(String cardNumber, isSmall) {
  Widget icon;
  switch (detectCCType(cardNumber)) {
    case CardType.visa:
      icon = Image.asset(
        'assets/image/visa.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    case CardType.americanExpress:
      icon = Image.asset(
        'assets/image/amex.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    case CardType.mastercard:
      icon = Image.asset(
        'assets/image/mastercard.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    case CardType.discover:
      icon = Image.asset(
        'assets/image/discover.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    default:
      icon = isSmall
          ? Image.asset(
              'assets/image/credit.png',
              height: isSmall ? 30 : 64,
              width: 64,
            )
          : Container();

      break;
  }

  return icon;
}

class MaskedTextController extends TextEditingController {
  Map<String, RegExp> translator;

  MaskedTextController({String text, this.mask, this.translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (this.beforeChange(previous, this.text)) {
        updateText(this.text);
        this.afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text != null) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: (text).length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}

String randomPic =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9qKR74yvV_QpYzSiDA6i5__nhX223h5WumQ&usqp=CAU';

Container getRandomBackground(double height, double width) {
  return Container(
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              "assets/image/card.png",
              height: height,
              width: width,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    ),
  );
}

Container getChipImage() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Image.asset(
      'assets/image/chip.png',
      height: 52,
      width: 52,
    ),
  );
}

class CreditCardForm extends StatefulWidget {
  CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.onCreditCardModelChange,
    this.themeColor,
    this.onChange,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  Function(
    String cardnumber,
    String expiryDate,
    String cardHolderName,
    String cvvCode,
  ) onChange;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

CreditCardModel creditCardModel;

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: .5),
          borderRadius: BorderRadius.circular(6)),
      child: Theme(
        data: ThemeData(
          primaryColor: themeColor.withOpacity(0.8),
          primaryColorDark: themeColor,
        ),
        child: Form(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: .5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        height: 45,
                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(
                          top: 14,
                        ),
                        child: TextFormField(
                          controller: _cardNumberController,
                          cursorColor: widget.cursorColor ?? themeColor,
                          style: TextStyle(
                            color: widget.textColor,
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                top: 10,
                                left: 16,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              labelText: 'card number',
                              hintText: 'xxxx xxxx xxxx xxxx',
                              hintStyle: TextStyle(
                                fontFamily: 'Grold',
                              ),
                              labelStyle: TextStyle(
                                  fontFamily: 'Grold', color: Colors.grey)),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        child: Container(
                            height: 25,
                            child: getCardTypeIcon(
                                _cardNumberController.text, true)),
                      ),
                    ),
                    // getCardTypeIcon(widget.cardNumber)
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: .5),
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 50,
                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(
                          top: 14,
                        ),
                        child: TextFormField(
                          controller: _expiryDateController,
                          cursorColor: widget.cursorColor ?? themeColor,
                          style: TextStyle(
                            color: widget.textColor,
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                top: 10,
                                left: 16,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              labelText: 'expiry date',
                              hintStyle: TextStyle(
                                fontFamily: 'Grold',
                              ),
                              labelStyle: TextStyle(
                                  fontFamily: 'Grold', color: Colors.grey),
                              hintText: 'MM/YY'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    Container(
                      child: Flexible(
                        child: Container(
                          height: 50,
                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(top: 14),
                          child: TextField(
                            focusNode: cvvFocusNode,
                            controller: _cvvCodeController,
                            cursorColor: widget.cursorColor ?? themeColor,
                            style: TextStyle(
                              color: widget.textColor,
                            ),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: 10,
                                  left: 16,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: 'CVV',
                                hintText: 'XXX',
                                hintStyle: TextStyle(
                                  fontFamily: 'Grold',
                                ),
                                labelStyle: TextStyle(
                                    fontFamily: 'Grold', color: Colors.grey)),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (String text) {
                              setState(() {
                                cvvCode = text;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                // padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(
                  top: 14,
                ),
                child: TextFormField(
                  controller: _cardHolderNameController,
                  cursorColor: widget.cursorColor ?? themeColor,
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        top: 10,
                        left: 16,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      labelText: 'card holder'.tr,
                      hintStyle: TextStyle(
                        fontFamily: 'Grold',
                      ),
                      labelStyle:
                          TextStyle(fontFamily: 'Grold', color: Colors.grey)),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),

              // GestureDetector(
              //   onTap: () {
              //     widget.onChange(
              //         _cardNumberController.text.toString(),
              //         _expiryDateController.text.toString(),
              //         _cardHolderNameController.text.toString(),
              //         _cvvCodeController.text.toString());
              //     print(_cardHolderNameController.text.toString() +
              //         _cardNumberController.text.toString() +
              //         _cvvCodeController.text.toString() +
              //         _expiryDateController.text.toString());
              //   },
              //   child: Container(
              //     child: Text("data"),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class CreditCardModel {
  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName,
      this.cvvCode, this.isCvvFocused);

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
}
