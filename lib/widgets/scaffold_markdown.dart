import "package:flutter/material.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:only_bible_app/utils.dart";

class ScaffoldMarkdown extends StatelessWidget {
  final String title;
  final String file;

  const ScaffoldMarkdown({super.key, required this.title, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString("assets/md/$file"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                styleSheet: MarkdownStyleSheet(
                  p: Theme.of(context).textTheme.bodyMedium,
                  h1: Theme.of(context).textTheme.headlineMedium,
                  h2: Theme.of(context).textTheme.headlineMedium,
                ),
                data: snapshot.data!,
                onTapLink: (text, href, title) {
                  openUrl(context, href!);
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
