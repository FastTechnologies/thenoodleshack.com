import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../../provider/paymet_provider.dart';
import '../../address/widget/add_button_view.dart';
import 'AddCardScreen.dart';
import 'components/card_widget.dart';

class MyPaymentMethodScreen extends StatefulWidget {
  MyPaymentMethodScreen({Key key}) : super(key: key);

  @override
  State<MyPaymentMethodScreen> createState() => _MyPaymentMethodScreenState();
}

class _MyPaymentMethodScreenState extends State<MyPaymentMethodScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<PaymentProvider>(context, listen: false)
          .getCardsList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(context: context, title: 'Wallet'),
      floatingActionButton: _isLoggedIn
          ? Padding(
              padding: EdgeInsets.only(
                  top: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.PADDING_SIZE_LARGE
                      : 0),
              child: !ResponsiveHelper.isDesktop(context)
                  ? FloatingActionButton(
                      child: Icon(Icons.add, color: Colors.white),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddCard()));
                      },
                    )
                  : null,
            )
          : null,
      body: _isLoggedIn
          ? Consumer<PaymentProvider>(
              builder: (context, paymentProvider, child) {
                return paymentProvider.cardsList != null
                    ? paymentProvider.cardsList.length > 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<PaymentProvider>(context,
                                      listen: false)
                                  .getCardsList(context);
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight:
                                                !ResponsiveHelper.isDesktop(
                                                            context) &&
                                                        _height < 600
                                                    ? _height
                                                    : _height - 400),
                                        child: SizedBox(
                                          width: 1170,
                                          child: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    AddButtonView(
                                                        onTap: () =>
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes.getAddAddressRoute(
                                                                    'address',
                                                                    'add',
                                                                    AddressModel(),
                                                                    amount:
                                                                        0.0))),
                                                    GridView.builder(
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              crossAxisSpacing:
                                                                  Dimensions
                                                                      .PADDING_SIZE_DEFAULT,
                                                              childAspectRatio:
                                                                  4),
                                                      padding: EdgeInsets.all(
                                                          Dimensions
                                                              .PADDING_SIZE_SMALL),
                                                      itemCount: paymentProvider
                                                          .cardsList.length,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              CardWidget(
                                                        paymentModel:
                                                            paymentProvider
                                                                    .cardsList[
                                                                index],
                                                        index: index,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.all(
                                                      Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  itemCount: paymentProvider
                                                      .cardsList.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          CardWidget(
                                                    paymentModel:
                                                        paymentProvider
                                                            .cardsList[index],
                                                    index: index,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    if (ResponsiveHelper.isDesktop(context))
                                      FooterView(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minHeight: !ResponsiveHelper.isDesktop(
                                                    context) &&
                                                _height < 600
                                            ? _height
                                            : _height - 400),
                                    width: 1177,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (ResponsiveHelper.isDesktop(context))
                                          AddButtonView(
                                              onTap: () => Navigator.pushNamed(
                                                  context,
                                                  Routes.getAddAddressRoute(
                                                      'address',
                                                      'add',
                                                      AddressModel()))),
                                        NoDataScreen(
                                            isFooter: false, isAddress: true),
                                      ],
                                    ),
                                  ),
                                ),
                                if (ResponsiveHelper.isDesktop(context))
                                  FooterView(),
                              ],
                            ),
                          )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)));
              },
            )
          : NotLoggedInScreen(),
    );
  }
}
