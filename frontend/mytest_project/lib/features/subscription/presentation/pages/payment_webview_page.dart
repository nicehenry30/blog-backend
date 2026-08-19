import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../bloc/subscription_bloc.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<PaymentWebViewPage> createState() =>
      _PaymentWebViewPageState();
}

class _PaymentWebViewPageState
    extends State<PaymentWebViewPage> {
  late final WebViewController controller;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              loading = true;
            });
          },
          onPageFinished: (_) {
            setState(() {
              loading = false;
            });
          },
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);

            if (uri.queryParameters.containsKey(
              'reference',
            )) {
              final reference =
                  uri.queryParameters['reference'];

              if (reference != null) {
                context
                    .read<SubscriptionBloc>()
                    .add(
                      VerifySubscriptionPayment(
                        reference,
                      ),
                    );

                Navigator.pop(
                  context,
                  true,
                );
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          widget.paymentUrl,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Secure Payment',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loading)
            const Center(
              child:
                  CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}