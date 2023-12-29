import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/aboutus.dart';
import 'package:flutter_firebase/services/auth.dart';

class PopupMenuWidget {
  static void showPopupMenu(BuildContext context) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition = (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    final double appBarHeight = AppBar().preferredSize.height;
   await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
         overlay.size.width - buttonPosition.dx - 10,
        buttonPosition.dy + appBarHeight + 30,
        overlay.size.width - buttonPosition.dx + 10,
        buttonPosition.dy + appBarHeight + 10,
      ),
      items: [
        const PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
        const PopupMenuItem(
          value: 'about',
          child: Text('About Us'),
        ),
      ],
      elevation: 8.0,
      color: Colors.white,
    ).then((value) {
      if (value == 'logout') {
        AuthServices().signOut();
      } else if (value == 'about') {
        Navigator.push( context,
                    MaterialPageRoute(
                                builder: (context) => AboutUsPage(context),
                              ),
                            );
      }
    });
  }
}
