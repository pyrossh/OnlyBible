import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

class MoreButton extends StatelessWidget {
  const MoreButton({super.key});

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
      onPressed: () => AppModel.ofEvent(context).showSettings(context),
      icon: const Icon(Icons.more_vert),
    );
  }
}
