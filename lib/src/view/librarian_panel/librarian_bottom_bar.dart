import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';

class LibrarianBottomBar extends StatelessWidget with PreferredSizeWidget {
  const LibrarianBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.fastest,
      height: preferredSize.height,
      child: Column(
        children: [
          Container(height: 1, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(59.0);
}
