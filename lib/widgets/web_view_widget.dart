import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:validators/validators.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  final String? url;
  const WebViewWidget({Key? key, this.url}) : super(key: key);

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late WebViewController webViewController;
  @override
  void dispose() {
    if (widget.url!.contains('http')) webViewController.clearCache();
    super.dispose();
  }

  String? searchUrl;
  @override
  Widget build(BuildContext context) {
    if (widget.url!.startsWith('http')) {
      setState(() => searchUrl = widget.url);
    } else {
      setState(() => searchUrl = 'https://${widget.url}');
    }

    return Scaffold(
      appBar: AppBar(),
      body: isURL(widget.url!)
          ? WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: Uri.encodeFull(searchUrl!),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onPageStarted: (url) {
                log('page loaded on => $url');
              },
            )
          : Center(
              child: Text(
                "Page Not Found",
                style: themeTextStyle(context: context),
              ),
            ),
    );
  }
}
