import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../features/language/presentation/provider/language_provider.dart';
import '../helper_function/api.dart';
import '../models/payment_result.dart';

class PaymentOnlinePage extends StatefulWidget {
  final num total;
  final String type;
  const PaymentOnlinePage({required this.total, super.key, required this.type});

  @override
  State<PaymentOnlinePage> createState() => _PaymentOnlinePageState();
}

class _PaymentOnlinePageState extends State<PaymentOnlinePage> {
  WebViewController controller = WebViewController();
  bool hasNavigated = false;

  NavigationDecision _finish(String result) {
    if (hasNavigated) return NavigationDecision.prevent;
    hasNavigated = true;
    Navigator.of(context).pop(result);
    return NavigationDecision.prevent;
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            String url = request.url;
            final result = PaymentResult.fromUrl(url);
            if (result != null) {
              debugPrint('paid');
              debugPrint(url);
              return _finish(result);
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('${Constants.baseUri}payment/${widget.total}/${widget.type}'),
        headers: {
          'Authorization':
              '${ApiHandel.getInstance.dio.options.headers['Authorization']}',
          'Accept': 'application/json',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text(LanguageProvider.translate("global", "payment_page")),
          // backgroundColor: AppColor.defaultColor,
          // foregroundColor: Colors.white,
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
