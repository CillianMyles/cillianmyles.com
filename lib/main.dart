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

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shortcuts(
        shortcuts: {
          // Web uses arrows for scrolling by default
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
              const DirectionalFocusIntent(TraversalDirection.up),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):
              const DirectionalFocusIntent(TraversalDirection.down),
        },
        child: SingleChildScrollView(
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
                    'Dad. Thinker. Engineer. \n'
                    'Building the future of productivity at Superlist ⚡️ \n'
                    'Writing about building amazing software experiences with Flutter and Dart! ✨',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _Button(
                    icon: const FaIcon(FontAwesomeIcons.lightbulb),
                    title: 'Blog',
                    url: Uri.parse('https://idiomaticbytes.com'),
                  ),
                  const SizedBox(height: 32),
                  _Button(
                    icon: const FaIcon(FontAwesomeIcons.xTwitter),
                    title: 'Twitter',
                    url: Uri.parse('https://x.com/IdiomaticBytes'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 32),
                  _Button(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    title: 'GitHub',
                    url: Uri.parse('https://github.com/CillianMyles'),
                  ),
                  const SizedBox(height: 32),
                  _Button(
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    title: 'LinkedIn',
                    url: Uri.parse('https://www.linkedin.com/in/cillianmyles'),
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

class _Button extends StatelessWidget {
  const _Button({
    required this.icon,
    required this.title,
    required this.url,
    this.autofocus = false,
  });

  final Widget icon;
  final String title;
  final Uri url;
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
    return Material(
      type: MaterialType.card,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
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
      ),
    );
  }
}
