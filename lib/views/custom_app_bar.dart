import 'package:flutter/material.dart';
import 'package:taskmate/views/texts.dart';

// GestureDetector CustomAppBar({
//   required Widget pageToPush,
//   required IconData icon,
// }) {
//   return CustomAppBar();
// }

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? pageToPush;
  final IconData? actionIcon;
  final String customTitle;
  final bool? addText;
  final bool? isCenterTitle;

  const CustomAppBar({
    required this.customTitle,
    this.pageToPush,
    this.actionIcon,
    this.addText,
    this.isCenterTitle,
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
            onTap: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _pageToPush!),
                );
              });
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFF47ADFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _addText
                  ? Row(
                      children: [
                        Icon(_icon, color: Color.fromARGB(255, 0, 68, 170)),
                        SizedBox(width: 4),
                        lilitaOneSmall(),
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
