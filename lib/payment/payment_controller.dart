import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {
  @override
  void onInit() {
    googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
    // cfPaymentGatewayService.setCallback(verifyPayment, onError, receivedEvent);

    super.onInit();
  }

  //============================================================ STRIPE ============================================================//
  String stripeSecretKey =
      "sk_test_51N6qLRSIOHzIzKEcudNSQBZhMgI7rO98trDTqRrEYfrGMJovk0ImpsiEvIl49DigVRo3RgZaYgdVpbio1wLCBdbu00lgo3GKys";
  Map<String, dynamic>? paymentIntent;
  int amount = 100;
  String currency = "USD";

  //PAYMENT INTENT
  Future<dynamic> createPaymentIntent(int amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': (amount * 100).toString(),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //MAKE PAYMENT
  Future<void> makePayment(context) async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent(amount, currency);
      log(paymentIntent.toString());

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          merchantDisplayName: 'Social',
        ),
      );

      //STEP 3: Display Payment sheet
      await displayPaymentSheet(context);
    } on StripeException catch (e) {
      log(e.toString());
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  Future<void> displayPaymentSheet(context) async {
    try {
      Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                SizedBox(height: 10.0),
                Text("Payment Successful!"),
              ],
            ),
          ),
        );

        paymentIntent = null;
      });
    } on StripeException catch (e) {
      log('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      log('$e');
    }
  }
  //============================================================ STRIPE ============================================================//

  //============================================================ RAZORPAY ============================================================//

  //RAZORPAY
  Future<void> razorPayPayments() async {
    Razorpay razorpay = Razorpay();
    Map<String, dynamic> options = {
      'key': 'rzp_test_MlAxpNlMcgFD9u',
      'amount': 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9824871769', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(Get.context!, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(Get.context!, "Payment Successful",
        "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        Get.context!, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Get.back();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //============================================================ RAZORPAY ============================================================//

  //============================================================ PAYPAL ============================================================//

  //PAYPAL
  Future<void> payPalPayment() async {
    Get.to(
      () => UsePaypal(
        sandboxMode: true,
        clientId:
            "AfP7fpkORDNR_TqRgvVZj_vXB6Ut2FGn9gMh_56JFQnMlfTeh5NYp45Bx4J0E8tRpiOhH6bf11qCJ2Ah",
        secretKey:
            "EPEucI-C3Zlxw5jNLrrFKYMNu04_Lq7-y3QmkoZQVQLPHAzH3vZU6Asq9CjCceexdy9tyUqPlR4-RQ2N",
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: const [
          {
            "amount": {
              "total": '100',
              "currency": "USD",
              "details": {
                "subtotal": '100',
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "The payment transaction description.",
            // "payment_options": {
            //   "allowed_payment_method":
            //       "INSTANT_FUNDING_SOURCE"
            // },
            "item_list": {
              "items": [
                {
                  "name": "A demo product",
                  "quantity": 1,
                  "price": '100',
                  "currency": "USD"
                }
              ],

              // shipping address is not required though
              "shipping_address": {
                "recipient_name": "Jane Foster",
                "line1": "Travis County",
                "line2": "",
                "city": "Austin",
                "country_code": "US",
                "postal_code": "73301",
                "phone": "+00000000",
                "state": "Texas"
              },
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
        },
        onError: (error) {
          log("onError: $error");
        },
        onCancel: (params) {
          log('cancelled: $params');
        },
      ),
    );
  }
  //============================================================ PAYPAL ============================================================//

  //============================================================ GOOGLE/APPLE PAY ============================================================//
  List<PaymentItem> paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  late final Future<PaymentConfiguration> googlePayConfigFuture;

  void onGooglePayResult(paymentResult) {
    log(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    log(paymentResult.toString());
  }
  //============================================================ GOOGLE/APPLE PAY ============================================================//

  //============================================================ CASH FREE PAY ============================================================//
  // String orderId = "order_18482OupTxSofcClBAlgqyYxUVceHo8";
  // String paymentSessionId =
  //     "session_oeYlKCusKyW5pND4Swzn1rE2-gwnoM8MOC2nck9RjIiUQwXcPLWB3U1xHaaItb-uA9H1k6Fwziq9O63DWcfYGy_3B7rl1nDFo3MMeVqiYrBr";

  // CFEnvironment environment = CFEnvironment.PRODUCTION;
  // CFPaymentGatewayService cfPaymentGatewayService = CFPaymentGatewayService();
  // void verifyPayment(String orderId) {
  //   log("Verify Payment");
  // }

  // void onError(CFErrorResponse errorResponse, String orderId) {
  //   log(errorResponse.getMessage().toString());
  //   log("Error while making payment");
  // }

  // void receivedEvent(String eventName, Map<dynamic, dynamic> metaData) {
  //   log(eventName);
  //   log(metaData.toString());
  // }

  // CFSession? createSession() {
  //   try {
  //     var session = CFSessionBuilder()
  //         .setEnvironment(environment)
  //         .setOrderId(orderId)
  //         .setPaymentSessionId(paymentSessionId)
  //         .build();
  //     return session;
  //   } on CFException catch (e) {
  //     log(e.message);
  //   }
  //   return null;
  // }

  // Future<void> cashFreePay() async {
  //   try {
  //     var session = createSession();
  //     List<CFPaymentModes> components = <CFPaymentModes>[];
  //     CFPaymentComponent paymentComponent =
  //         CFPaymentComponentBuilder().setComponents(components).build();

  //     CFTheme theme = CFThemeBuilder()
  //         .setNavigationBarBackgroundColorColor("#FF0000")
  //         .setPrimaryFont("Menlo")
  //         .setSecondaryFont("Futura")
  //         .build();

  //     CFDropCheckoutPayment cfDropCheckoutPayment =
  //         CFDropCheckoutPaymentBuilder()
  //             .setSession(session!)
  //             .setPaymentComponent(paymentComponent)
  //             .setTheme(theme)
  //             .build();

  //     cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
  //   } on CFException catch (e) {
  //     log(e.message);
  //   }
  // }
}
