import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
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
  WebViewController? controller;

  bool loading = true;
  bool verifying = false;
  bool callbackDetected = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _initializeWebView();
    } else {
      _openPaymentInBrowser();
    }
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                loading = true;
              });
            }

            _checkPaymentCallback(url);
          },

          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                loading = false;
              });
            }

            _checkPaymentCallback(url);
          },

          onNavigationRequest: (request) {
            _checkPaymentCallback(request.url);

            /*
             * Allow the navigation so Laravel's callback
             * page can complete the Paystack verification.
             */
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.paymentUrl),
      );
  }

  Future<void> _openPaymentInBrowser() async {
    final uri = Uri.parse(widget.paymentUrl);

    final launched = await launchUrl(
      uri,
      webOnlyWindowName: '_blank',
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open the Paystack payment page.',
          ),
        ),
      );
    }
  }

  void _checkPaymentCallback(String url) {
    if (callbackDetected || verifying) {
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    /*
     * We only want to react to OUR Laravel callback.
     *
     * This prevents random Paystack navigation URLs
     * from triggering verification.
     */
    final isPaymentCallback =
        uri.path == '/admin/payment/callback';

    if (!isPaymentCallback) {
      return;
    }

    final reference =
        uri.queryParameters['reference'];

    if (reference == null || reference.isEmpty) {
      return;
    }

    callbackDetected = true;
    verifying = true;

    /*
     * Ask Laravel to verify the payment using the
     * authenticated API.
     *
     * Laravel will verify the transaction with Paystack
     * and activate the exact subscription attached to
     * this payment.
     */
    context.read<SubscriptionBloc>().add(
          VerifySubscriptionPayment(reference),
        );

    /*
     * Give the BLoC event time to reach the repository.
     *
     * We do NOT immediately pop before dispatching
     * verification as the old implementation did.
     */
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) {
          return;
        }

        Navigator.pop(
          context,
          true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Secure Payment',
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.open_in_new,
                  size: 48,
                ),

                SizedBox(height: 16),

                Text(
                  'Paystack payment opened in a new browser tab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Complete your payment there, then return to Tradewisser.',
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                Text(
                  'Your subscription will be verified automatically.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Secure Payment',
        ),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          if (controller != null)
            WebViewWidget(
              controller: controller!,
            ),

          if (loading || verifying)
            Container(
              color: Colors.black.withValues(
                alpha: 0.15,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}