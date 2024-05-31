import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cillian Myles",
      theme: _themeData(Brightness.light),
      darkTheme: _themeData(Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: const _Page(),
    );
  }
}

ThemeData _themeData(Brightness brightness) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey,
      brightness: brightness,
    ),
    useMaterial3: true,
  );
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  final _focusNode1 = FocusNode(debugLabel: '1');
  final _focusNode2 = FocusNode(debugLabel: '2');
  final _focusNode3 = FocusNode(debugLabel: '3');
  final _focusNode4 = FocusNode(debugLabel: '4');

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: <ShortcutActivator, Intent>{
        // Web uses arrows for scrolling by default
        const SingleActivator(LogicalKeyboardKey.arrowUp):
            const DirectionalFocusIntent(TraversalDirection.up),
        const SingleActivator(LogicalKeyboardKey.arrowDown):
            const DirectionalFocusIntent(TraversalDirection.down),
        // Tile shortcuts
        const SingleActivator(LogicalKeyboardKey.keyA):
            RequestFocusIntent(_focusNode1),
        const SingleActivator(LogicalKeyboardKey.keyB):
            RequestFocusIntent(_focusNode2),
        const SingleActivator(LogicalKeyboardKey.keyC):
            RequestFocusIntent(_focusNode3),
        const SingleActivator(LogicalKeyboardKey.keyD):
            RequestFocusIntent(_focusNode4),
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Material(
                      type: MaterialType.card,
                      borderRadius: BorderRadius.circular(9999),
                      clipBehavior: Clip.antiAlias,
                      elevation: 16,
                      child: Image.asset('assets/images/cillian.jpg'),
                    ),
                  ),
                  Text(
                    'Dad. Thinker. Engineer.\n'
                    'Building the future of productivity at Superlist ⚡️\n'
                    'Writing about building amazing software experiences with Flutter and Dart! ✨',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.lightbulb),
                    title: 'Blog',
                    url: Uri.parse('https://idiomaticbytes.com'),
                    focusNode: _focusNode1,
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.xTwitter),
                    title: 'Twitter',
                    url: Uri.parse('https://x.com/IdiomaticBytes'),
                    focusNode: _focusNode2,
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    title: 'GitHub',
                    url: Uri.parse('https://github.com/CillianMyles'),
                    focusNode: _focusNode3,
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    title: 'LinkedIn',
                    url: Uri.parse('https://www.linkedin.com/in/cillianmyles'),
                    focusNode: _focusNode4,
                  ),
                  const SizedBox(height: 128),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.url,
    required this.focusNode,
    this.autofocus = false,
  });

  final Widget icon;
  final String title;
  final Uri url;
  final FocusNode focusNode;
  final bool autofocus;

  Future<void> _launchUrl() async {
    final succeeded = await launchUrl(
      url,
      webOnlyWindowName: '_blank',
    );
    if (!succeeded) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 600;

    final tile = ListTile(
      focusNode: focusNode,
      autofocus: autofocus,
      onTap: _launchUrl,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final Widget result;

    if (desktop) {
      // result = Row(
      //   mainAxisSize: MainAxisSize.max,
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     SizedBox(
      //       width: 40,
      //       child: ElevatedButton(
      //         onPressed: () => _focusNode.requestFocus(),
      //         child: Text(_keys[widget.activatorKey]!),
      //       ),
      //     ),
      //     const SizedBox(width: 8),
      //     tile,
      //     const SizedBox(width: 8),
      //     SizedBox(
      //       width: 40,
      //       child: ElevatedButton(
      //         onPressed: _launchUrl,
      //         child: const Text('⏎'),
      //       ),
      //     ),
      //   ],
      // );
      result = tile;
    } else {
      result = tile;
    }

    return Material(
      type: MaterialType.card,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: result,
    );
  }
}
