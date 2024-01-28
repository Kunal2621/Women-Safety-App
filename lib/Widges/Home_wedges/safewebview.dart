import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class safewebview extends StatelessWidget {
  final String? url;
  safewebview({this.url});

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: WebView(
      initialUrl: url,
     ),
   );
     }
}