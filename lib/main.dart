import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🔗Links',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusScope(
      autofocus: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('🔗Links'),
            SizedBox(height: 32),
            _Button(
              url: 'https://github.com/IdiomaticBytes',
              debugLabel: 'X',
              autofocus: true,
              child: Text('X'),
            ),
            SizedBox(height: 32),
            _Button(
              url: 'https://github.com/CillianMyles',
              debugLabel: 'GitHub',
              child: Text('GitHub'),
            ),
            SizedBox(height: 32),
            _Button(
              url: 'https://www.linkedin.com/in/cillianmyles',
              debugLabel: 'LinkedIn',
              child: Text('LinkedIn'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({
    required this.child,
    required this.url,
    required this.debugLabel,
    this.autofocus = false,
  });

  final Widget child;
  final String url;
  final String debugLabel;
  final bool autofocus;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  var _hovered = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: widget.debugLabel)..requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onEnter(PointerEnterEvent event) {
    if (!_hovered) {
      setState(() {
        _hovered = true;
      });
    }
  }

  void _onExit(PointerExitEvent event) {
    if (_hovered) {
      setState(() {
        _hovered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: _focusNode,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _onEnter,
        onExit: _onExit,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: _focusNode.hasFocus || _hovered
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surface.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(8),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              overflow: TextOverflow.ellipsis,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
