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
     * Laravel callback route.
     *
     * IMPORTANT:
     * This used to be:
     *
     * /admin/payment/callback
     *
     * It is now:
     *
     * /payment/callback
     */
    final isPaymentCallback =
        uri.path == '/payment/callback';

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

    if (mounted) {
      setState(() {});
    }

    /*
     * Verify the payment through the authenticated
     * Laravel API.
     */
    context.read<SubscriptionBloc>().add(
          VerifySubscriptionPayment(reference),
        );

    /*
     * Give the BLoC time to process the verification
     * before returning to the subscription page.
     */
    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        if (!mounted) {
          return;
        }

        Navigator.of(context).pop(true);
      },
    );
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
     * Flutter Web
     *
     * Paystack is opened in a separate browser tab.
     */
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
            tooltip: 'Back',
          ),
          title: const Text(
            'Secure Payment',
          ),
          centerTitle: true,
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.open_in_new,
                  size: 48,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Paystack payment opened in a new browser tab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Complete your payment there, then return to Tradewisser.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Your subscription will be verified automatically.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                ElevatedButton.icon(
                  onPressed: _goBack,
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  label: const Text(
                    'Back to Plans',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    /*
     * Android / iOS WebView
     */
    return PopScope(
      canPop: !verifying,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        if (!verifying) {
          _goBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: verifying ? null : _goBack,
            tooltip: 'Back',
          ),
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
      ),
    );
  }
}