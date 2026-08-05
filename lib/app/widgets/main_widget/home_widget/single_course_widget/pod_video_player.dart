import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../common/common.dart';

class WebViewVideoPlayer extends StatefulWidget {
  final String type;
  final String url;
  final RouteObserver<ModalRoute<void>> routeObserver;

  const WebViewVideoPlayer(this.url, this.type, this.routeObserver, {super.key});

  @override
  State<WebViewVideoPlayer> createState() => _WebViewVideoPlayerState();
}

class _WebViewVideoPlayerState extends State<WebViewVideoPlayer> with RouteAware {
  late WebViewController _webViewController;
  bool _isInitializing = false;
  UniqueKey _playerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    
    // Enable landscape mode for fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initializeWebViewController() async {
    setState(() {
      _isInitializing = true;
    });
    
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isInitializing = false;
                });
              }
              // Inject script to handle menu interactions
              _injectMenuHandler();
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('WebView error: ${error.description}');
            },
          ),
        )
        ..loadHtmlString(_buildHtmlContent());
    } catch (e) {
      debugPrint('Error initializing WebView controller: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _injectMenuHandler() async {
    await _webViewController.runJavaScript('''
      document.addEventListener('click', function(event) {
        var target = event.target;
        // Allow clicks to close menus
        if (target.closest('.menu') || target.closest('[role="menuitem"]')) {
          event.stopPropagation();
        }
      }, true);
      
      // Handle escape key to close menus
      document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
          var openMenus = document.querySelectorAll('[role="menu"][aria-hidden="false"]');
          openMenus.forEach(function(menu) {
            menu.setAttribute('aria-hidden', 'true');
          });
        }
      });
    ''');
  }

  String _buildHtmlContent() {
    final baseHtml = '''
    <!DOCTYPE html>
    <html style="width: 100%; height: 100%;">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        html, body {
          width: 100%;
          height: 100%;
          margin: 0;
          padding: 0;
          background-color: #000;
          overflow: hidden;
        }
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        body {
          display: flex;
          justify-content: center;
          align-items: center;
          flex-direction: column;
        }
        .video-container {
          width: 100%;
          height: 100%;
          position: relative;
          display: flex;
          justify-content: center;
          align-items: center;
          overflow: hidden;
        }
        iframe, video {
          width: 100% !important;
          height: 100% !important;
          border: none;
          object-fit: contain;
          display: block;
        }
        /* Prevent menu overflow */
        [role="menu"], 
        [role="listbox"],
        .settings-menu,
        .context-menu {
          max-width: 100vw !important;
          max-height: 100vh !important;
          overflow: auto !important;
        }
      </style>
    </head>
    <body>
      <div class="video-container">
        ${_getVideoEmbed()}
      </div>
      ${_getVideoScript()}
    </body>
    </html>
    ''';
    return baseHtml;
  }

  String _getVideoEmbed() {
    switch (widget.type.toLowerCase()) {
      case 'youtube':
        return _getYouTubeEmbed();
      case 'vimeo':
        return _getVimeoEmbed();
      case 'network':
      default:
        return _getNetworkVideoEmbed();
    }
  }

  String _getYouTubeEmbed() {
    final videoId = _extractYouTubeId(widget.url);
    return '''
      <iframe
        id="videoPlayer"
        src="https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&modestbranding=1"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      ></iframe>
    ''';
  }

  String _getVimeoEmbed() {
    final videoId = widget.url.split('/').last;
    return '''
      <iframe
        id="videoPlayer"
        src="https://player.vimeo.com/video/$videoId?autoplay=1&api=1&player_id=videoPlayer"
        allow="autoplay; fullscreen; picture-in-picture"
        allowfullscreen
      ></iframe>
      <script src="https://player.vimeo.com/api/player.js"></script>
    ''';
  }

  String _getNetworkVideoEmbed() {
    return '''
      <video
        id="videoPlayer"
        width="100%"
        height="100%"
        controls
        autoplay
        style="max-width: 100%; max-height: 100%; display: block;"
      >
        <source src="${widget.url}" type="video/mp4">
        Your browser does not support the video tag.
      </video>
    ''';
  }

  String _getVideoScript() {
    if (widget.type.toLowerCase() == 'vimeo') {
      return '''
        <script>
          function handleFullscreenChange() {
            var elem = document.fullscreenElement || 
                       document.webkitFullscreenElement || 
                       document.mozFullScreenElement;
            if (!elem) {
              // Exited fullscreen
              setTimeout(function() {
                var iframe = document.getElementById('videoPlayer');
                if (iframe) {
                  iframe.style.width = '100%';
                  iframe.style.height = '100%';
                }
              }, 100);
            }
          }
          
          document.addEventListener('fullscreenchange', handleFullscreenChange);
          document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
          document.addEventListener('mozfullscreenchange', handleFullscreenChange);
          document.addEventListener('MSFullscreenChange', handleFullscreenChange);
        </script>
      ''';
    }
    return '';
  }

  String _extractYouTubeId(String url) {
    // Handle various YouTube URL formats
    if (url.contains('youtu.be/')) {
      return url.split('youtu.be/').last.split('?').first;
    } else if (url.contains('youtube.com/watch')) {
      return Uri.parse(url).queryParameters['v'] ?? '';
    } else if (url.contains('youtube.com/embed/')) {
      return url.split('youtube.com/embed/').last.split('?').first;
    }
    return url;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    // Reset to portrait mode when disposing
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void didPush() {
    // Called when the current route has been pushed
  }

  @override
  void didPushNext() {
    // Called when a new route has been pushed, and the current route is no longer visible
    // WebView will pause video automatically
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped, and the current route shows up
    // WebView will resume video automatically
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ClipRRect(
            borderRadius: borderRadius(),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildVideoPlayer(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoPlayer() {
    if (_isInitializing) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return WebViewWidget(
      key: _playerKey,
      controller: _webViewController,
    );
  }
}