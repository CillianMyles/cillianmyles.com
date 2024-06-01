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
  final _tiles = <_TileFocusData>[
    _TileFocusData(label: 'B', key: LogicalKeyboardKey.keyB),
    _TileFocusData(label: 'X', key: LogicalKeyboardKey.keyX),
    _TileFocusData(label: 'G', key: LogicalKeyboardKey.keyG),
    _TileFocusData(label: 'L', key: LogicalKeyboardKey.keyL),
  ];

  @override
  void dispose() {
    for (final tile in _tiles) {
      tile.focusNode.dispose();
    }
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
        for (final tile in _tiles)
          SingleActivator(tile.key): RequestFocusIntent(tile.focusNode),
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
                    focusData: _tiles[0],
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.xTwitter),
                    title: 'Twitter',
                    url: Uri.parse('https://x.com/IdiomaticBytes'),
                    focusData: _tiles[1],
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    title: 'GitHub',
                    url: Uri.parse('https://github.com/CillianMyles'),
                    focusData: _tiles[2],
                  ),
                  const SizedBox(height: 32),
                  _Tile(
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    title: 'LinkedIn',
                    url: Uri.parse('https://www.linkedin.com/in/cillianmyles'),
                    focusData: _tiles[3],
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

class _TileFocusData {
  _TileFocusData({
    required this.label,
    required this.key,
  }) : focusNode = FocusNode(debugLabel: label);

  final String label;
  final LogicalKeyboardKey key;
  final FocusNode focusNode;
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.url,
    required this.focusData,
  });

  final Widget icon;
  final String title;
  final Uri url;
  final _TileFocusData focusData;

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
    final Widget icon;

    if (desktop) {
      icon = OutlinedButton(
        onPressed: () => focusData.focusNode.requestFocus(),
        child: Text(
          focusData.focusNode.hasFocus ? '⏎' : focusData.label,
        ),
      );
    } else {
      icon = this.icon;
    }

    final tile = ListTile(
      focusNode: focusData.focusNode,
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

    return Material(
      type: MaterialType.card,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: tile,
    );
  }
}
