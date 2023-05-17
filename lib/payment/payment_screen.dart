import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:social_login_payment/payment/payment_configurations.dart';
import 'package:social_login_payment/payment/payment_controller.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});
  final PaymentController _con = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stripe"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          ElevatedButton(
            onPressed: () => _con.makePayment(context),
            child: Text("Pay with stripe ${_con.amount}"),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => _con.razorPayPayments(),
            child: Text("Pay with razorpay ${_con.amount}"),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => _con.payPalPayment(),
            child: Text("Pay with paypal ${_con.amount}"),
          ),
          const SizedBox(
            height: 10,
          ),

          //Default Google Pay
          FutureBuilder<PaymentConfiguration>(
            future: _con.googlePayConfigFuture,
            builder: (context, snapshot) => snapshot.hasData
                ? GooglePayButton(
                    paymentConfiguration: snapshot.data!,
                    paymentItems: _con.paymentItems,
                    type: GooglePayButtonType.checkout,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: _con.onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 15),

          //Default Apple Pay
          ApplePayButton(
            paymentConfiguration:
                PaymentConfiguration.fromJsonString(defaultApplePay),
            paymentItems: _con.paymentItems,
            style: ApplePayButtonStyle.black,
            type: ApplePayButtonType.buy,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: _con.onApplePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(height: 15),

          // ElevatedButton(
          //   onPressed: () => _con.cashFreePay(),
          //   child: Text("Pay with Cash Free ${_con.amount}"),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
