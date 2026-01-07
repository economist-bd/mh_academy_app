import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'MH Academy',
    home: BlogWebView(),
  ));
}

class BlogWebView extends StatefulWidget {
  const BlogWebView({super.key});

  @override
  State<BlogWebView> createState() => _BlogWebViewState();
}

class _BlogWebViewState extends State<BlogWebView> {
  late final WebViewController _controller;
  bool _isLoading = true; // লোডিং দেখানোর জন্য

  @override
  void initState() {
    super.initState();
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      // ==========================================
      // আপনার ব্লগের লিংক এখানে দেওয়া হলো
      // ==========================================
      ..loadRequest(Uri.parse('https://mhacademy-economics.blogspot.com'));
  }

  @override
  Widget build(BuildContext context) {
    // ব্যাক বাটন হ্যান্ডলিং (যাতে অ্যাপ বন্ধ না হয়ে আগের পেজে যায়)
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        // অ্যাপ বারে রিফ্রেশ বাটন রাখা হলো
        appBar: AppBar(
          title: const Text("MH Academy Economics"),
          backgroundColor: const Color(0xFF2E7D32), // অর্থনীতির থিম হিসেবে সবুজ রাখা হলো
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            
            // লোডিং ইন্ডিকেটর
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              ),
          ],
        ),
      ),
    );
  }
}