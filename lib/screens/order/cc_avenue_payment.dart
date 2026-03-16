import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CCAvenuePayment extends StatefulWidget {

  final String encRequest;
  final String accessCode;

  const CCAvenuePayment({
    super.key,
    required this.encRequest,
    required this.accessCode,
  });

  @override
  State<CCAvenuePayment> createState() => _CCAvenuePaymentState();
}

class _CCAvenuePaymentState extends State<CCAvenuePayment> {

  late final WebViewController controller;

  @override
  void initState() {

    super.initState();

    final url =
        "https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction&encRequest=${widget.encRequest}&access_code=${widget.accessCode}";

    controller = WebViewController()

      ..setJavaScriptMode(JavaScriptMode.unrestricted)

      ..setNavigationDelegate(

        NavigationDelegate(

          onNavigationRequest: (request) {

            if (request.url.contains("payment_success")) {
              Get.back(result: "success");
            }

            if (request.url.contains("payment_cancel")) {

              Get.back(result: "failed");

            }

            return NavigationDecision.navigate;

          },

        ),

      )

      ..loadRequest(Uri.parse(url));

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: WebViewWidget(controller: controller),
    );

  }

}