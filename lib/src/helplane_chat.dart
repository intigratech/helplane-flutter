import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'helplane.dart';

/// A widget that displays the HelpLane chat interface.
///
/// This widget uses a WebView to render the HelpLane chat widget.
/// Make sure to call [HelpLane.configure] before using this widget.
class HelpLaneChat extends StatefulWidget {
  /// Called when the chat widget finishes loading.
  final VoidCallback? onLoad;

  /// Called when an error occurs loading the chat widget.
  final void Function(String error)? onError;

  /// Creates a new [HelpLaneChat] widget.
  const HelpLaneChat({
    super.key,
    this.onLoad,
    this.onError,
  });

  @override
  State<HelpLaneChat> createState() => _HelpLaneChatState();
}

class _HelpLaneChatState extends State<HelpLaneChat> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            widget.onLoad?.call();
          },
          onWebResourceError: (error) {
            setState(() => _isLoading = false);
            widget.onError?.call(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(HelpLane.instance.buildChatUrl()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
