import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class AppGameScreen extends StatefulWidget {
  const AppGameScreen({super.key});

  @override
  State<AppGameScreen> createState() => _AppGameScreenState();
}

class _AppGameScreenState extends State<AppGameScreen> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  void initState() {
    super.initState();
    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Restore system UI when leaving this screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(''),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
            _progress < 1 ? const LoadingScreen() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xffd8cccc),
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(
      //       'assets/images/homeBG.png',
      //     ),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 150.0,
          ),
          const SizedBox(height: 25.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: LinearProgressIndicator(
              color: Colors.grey,
            ),
          ),
          // const Text(
          //   'Loading...',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 18.0,
          //   ),
          // )
        ],
      ),
    );
  }
}
