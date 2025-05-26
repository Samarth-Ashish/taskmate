import 'package:flutter/material.dart';
import 'package:taskmate/views/texts.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? pageToPush;
  final IconData? actionIcon;
  final String customTitle;
  final bool? addText;
  final bool? isCenterTitle;
  final GestureTapCallback? onTap;

  const CustomAppBar({
    required this.customTitle,
    this.pageToPush,
    this.actionIcon,
    this.addText,
    this.isCenterTitle,
    this.onTap,
    super.key,
  });

  @override
  State<CustomAppBar> createState() => CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  Widget? get _pageToPush => widget.pageToPush;
  IconData? get _icon => widget.actionIcon;
  String get _title => widget.customTitle;
  bool get _addText => widget.addText ?? true;
  bool get _isCenterTitle => widget.isCenterTitle ?? false;

  @override
  Widget build(BuildContext context) {
    debugPrint('Building CustomAppBarState');
    return AppBar(
      title: lobsterAppBarText(_title),
      centerTitle: _isCenterTitle,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[Color(0xFF9ED8FC), Color(0xFF67BFF9)],
          ),
        ),
      ),
      actions: [
        if (_icon != null)
          GestureDetector(
            onTap:
                widget.onTap ??
                () {
                  if (_pageToPush != null &&
                      (_pageToPush.runtimeType != this.runtimeType)) {
                    debugPrint('==========Pushing page==========');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => _pageToPush!), //
                    ).then((value) {
                      if (value == true && widget.onTap != null) {
                        widget.onTap!();
                      }
                    });
                  }
                },
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    Color.fromARGB(255, 93, 204, 255),
                    Color.fromARGB(255, 0, 160, 247),
                  ],
                  stops: [0.0, 1.0],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: _addText
                  ? Row(
                      children: [
                        Icon(_icon, color: Color.fromARGB(255, 0, 68, 170)),
                        SizedBox(width: 4),
                        lilitaOneAddText(),
                        SizedBox(width: 8),
                      ],
                    )
                  : Icon(_icon, color: Color.fromARGB(255, 0, 68, 170)),
            ),
          ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
