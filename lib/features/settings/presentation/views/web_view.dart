import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../language/presentation/provider/language_provider.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String link;
  const WebViewPage({required this.title, required this.link, super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController controller = WebViewController();
  bool isLoading = true;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.link);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            if (mounted) setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            if (!mounted || error.isForMainFrame == false) return;
            setState(() {
              isLoading = false;
              errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final requested = Uri.tryParse(request.url);
            if (requested == null || requested.scheme != 'https') {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      isLoading = false;
      errorMessage = LanguageProvider.translate('error', 'invalid_link');
    } else {
      controller.loadRequest(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LanguageProvider.translate('settings', widget.title)),
        ),
        body: errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 42),
                      const SizedBox(height: 12),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            errorMessage = null;
                            isLoading = true;
                          });
                          controller.reload();
                        },
                        child: Text(
                          LanguageProvider.translate('buttons', 'retry'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
      ),
    );
  }
}
