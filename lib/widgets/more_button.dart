import "package:flutter/material.dart";
import "package:only_bible_app/widgets/settings_sheet.dart";

class MoreButton extends StatefulWidget {
  const MoreButton({super.key});

  @override
  State<MoreButton> createState() => _MoreButtonState();
}

class _MoreButtonState extends State<MoreButton> {
  var isOpen = false;

  setIsOpen() {
    setState(() {
      isOpen = true;
    });
  }

  setIsClosed() {
    setState(() {
      isOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   enableDrag: false,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(
    //       top: Radius.circular(20),
    //     ),
    //   ),
    //   clipBehavior: Clip.antiAliasWithSaveLayer,
    //   builder: (context) => DraggableScrollableSheet(
    //     expand: false,
    //     initialChildSize: 0.9,
    //     minChildSize: 0.5,
    //     maxChildSize: 0.9,
    //     builder: (context, scrollController) {
    //       return SingleChildScrollView(
    //         child: new Container(
    //           color: Colors.white,
    //           child: buildTitleWidget(),
    //         ),
    //       );
    //     },
    //   ),
    //   isDismissible: false,
    //   isScrollControlled: true,
    // );
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          enableDrag: true,
          useSafeArea: true,
          builder: (context) => const SettingsSheet(),
        );
      },
      icon: const Icon(Icons.more_vert),
    );
  }
}
