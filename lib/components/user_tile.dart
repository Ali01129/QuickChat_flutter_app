import 'package:flutter/material.dart';
class UserTile extends StatelessWidget {
  String text;
  final void Function()? onTap;
  UserTile({super.key,required this.text,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.purple.shade100,
        ),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person),
            const SizedBox(width: 15,),
            Text(text),
          ],
        ),
      ),
    );
  }
}
