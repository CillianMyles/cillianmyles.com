import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

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
  final _tiles = [
    _Tiles.email,
    _Tiles.resume,
    _Tiles.twitter,
    _Tiles.gitHub,
    _Tiles.linkedIn,
    _Tiles.blog,
    _Tiles.youTube,
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
          SingleActivator(tile.keyboardKey): RequestFocusIntent(tile.focusNode),
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _ConstrainedContent(
                alignment: Alignment.topCenter,
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
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index.isEven) {
                    return const SizedBox(height: 32);
                  } else {
                    final tile = _tiles[(index - 1) ~/ 2];
                    return _Tile(data: tile);
                  }
                },
                childCount: _tiles.length * 2 + 1,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 128),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tiles {
  const _Tiles._();

  static final email = _TileData(
    iconData: FontAwesomeIcons.envelope,
    title: 'Email',
    keyLabel: 'E',
    keyboardKey: LogicalKeyboardKey.keyE,
    tapAction: const _CopyToClipboard(
      text: 'getme@cillianmyles.com',
      message: 'Email copied to clipboard!',
    ),
  );

  static final resume = _TileData(
    iconData: FontAwesomeIcons.fileLines,
    title: 'Resume / CV',
    keyLabel: 'R',
    keyboardKey: LogicalKeyboardKey.keyR,
    tapAction: _DownloadFile(
      url: Uri.parse(
        'https://raw.githubusercontent.com/CillianMyles/cillianmyles.com/refs/heads/main/assets/docs/Cillian_Myles_Resume.pdf',
      ),
      message: 'Resume downloaded!',
    ),
  );

  static final twitter = _TileData(
    iconData: FontAwesomeIcons.xTwitter,
    title: 'Twitter',
    keyLabel: 'X',
    keyboardKey: LogicalKeyboardKey.keyX,
    tapAction: _LaunchUrl(
      Uri.parse('https://x.com/IdiomaticBytes'),
    ),
  );

  static final gitHub = _TileData(
    iconData: FontAwesomeIcons.github,
    title: 'GitHub',
    keyLabel: 'G',
    keyboardKey: LogicalKeyboardKey.keyG,
    tapAction: _LaunchUrl(
      Uri.parse('https://github.com/CillianMyles'),
    ),
  );

  static final linkedIn = _TileData(
    iconData: FontAwesomeIcons.linkedin,
    title: 'LinkedIn',
    keyLabel: 'L',
    keyboardKey: LogicalKeyboardKey.keyL,
    tapAction: _LaunchUrl(
      Uri.parse('https://www.linkedin.com/in/cillianmyles'),
    ),
  );

  static final blog = _TileData(
    iconData: FontAwesomeIcons.lightbulb,
    title: 'Blog',
    keyLabel: 'B',
    keyboardKey: LogicalKeyboardKey.keyB,
    tapAction: _LaunchUrl(
      Uri.parse('https://idiomaticbytes.com'),
    ),
  );

  static final youTube = _TileData(
    iconData: FontAwesomeIcons.youtube,
    title: 'YouTube',
    keyLabel: 'Y',
    keyboardKey: LogicalKeyboardKey.keyY,
    tapAction: _LaunchUrl(
      Uri.parse('https://www.youtube.com/@IdiomaticBytes'),
    ),
  );
}

sealed class _TapAction {
  const _TapAction();
}

class _LaunchUrl extends _TapAction {
  const _LaunchUrl(this.url);
  final Uri url;
}

class _CopyToClipboard extends _TapAction {
  const _CopyToClipboard({
    required this.text,
    this.message,
  });

  final String text;
  final String? message;
}

class _DownloadFile extends _TapAction {
  const _DownloadFile({
    required this.url,
    this.message,
  });

  final Uri url;
  final String? message;
}

class _TileData {
  _TileData({
    required this.iconData,
    required this.title,
    required this.keyLabel,
    required this.keyboardKey,
    required this.tapAction,
  }) : focusNode = FocusNode(debugLabel: keyLabel);

  final IconData iconData;
  final String title;
  final String keyLabel;
  final LogicalKeyboardKey keyboardKey;
  final FocusNode focusNode;
  final _TapAction tapAction;
}

class _Tile extends StatefulWidget {
  const _Tile({
    required this.data,
  });

  final _TileData data;

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  static const _tapRegionGroupId = '_Tile';

  @override
  void initState() {
    super.initState();
    widget.data.focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  Future<void> _onTap() async {
    switch (widget.data.tapAction) {
      case _LaunchUrl(url: final url):
        await _launchUrl(url);
      case _CopyToClipboard(text: final text, message: final message):
        await _copyToClipboard(text: text, message: message);
      case _DownloadFile(url: final url, message: final message):
        await _downloadFile(url: url, message: message);
    }
  }

  Future<void> _launchUrl(Uri url) async {
    final succeeded = await launchUrl(
      url,
      webOnlyWindowName: '_blank',
    );
    if (!succeeded) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _copyToClipboard({
    required String text,
    String? message,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (mounted && message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _downloadFile({
    required Uri url,
    String? message,
  }) async {
    try {
      // For web, we use the AnchorElement to trigger the download
      html.AnchorElement(href: url.toString())
        ..setAttribute('download', '')
        ..click();

      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download failed!")),
      );
    }
  }

  void maybeUnfocus() {
    if (widget.data.focusNode.hasFocus) {
      widget.data.focusNode.unfocus();
    }
  }

  void unfocus() {
    widget.data.focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 600;
    final Widget icon;

    if (desktop) {
      icon = _KeyButton(
        child: widget.data.focusNode.hasFocus
            ? const Icon(Icons.keyboard_return)
            : Text(widget.data.keyLabel),
      );
    } else {
      icon = _Icon(
        iconData: widget.data.iconData,
      );
    }

    final tile = Actions(
      actions: {
        DismissIntent: CallbackAction(onInvoke: (_) => unfocus()),
      },
      child: TapRegion(
        groupId: _tapRegionGroupId,
        onTapOutside: (_) => maybeUnfocus(),
        child: ListTile(
          focusNode: widget.data.focusNode,
          onTap: _onTap,
          leading: icon,
          title: Text(
            widget.data.title,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    return _ConstrainedContent(
      child: Material(
        type: MaterialType.card,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: tile,
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primarySize = 22.0;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        border: Border.all(
          width: 1.0,
          color: theme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            offset: const Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryColor,
          fontSize: primarySize,
          fontWeight: FontWeight.w500,
        ),
        child: IconTheme.merge(
          data: IconThemeData(
            color: primaryColor,
            size: primarySize,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.iconData,
  });

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: FaIcon(
        iconData,
        size: 22,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _ConstrainedContent extends StatelessWidget {
  const _ConstrainedContent({
    this.alignment = Alignment.center,
    required this.child,
  });

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
