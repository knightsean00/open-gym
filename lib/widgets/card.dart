import 'package:flutter/material.dart';

class GymCard extends StatelessWidget {
  final String title;
  final String body;
  final Function? target;
  final bool active;

  GymCard({
    super.key,
    required this.title,
    required this.body,
    this.target,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        // onTap: target!(),
        onTap: (target != null
            ? target!()
            : () {
                print("Widget tapped");
              }),
        child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Expanded(
              child: Column(
                children: [
                  Text(title,
                      maxLines: 1, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
                  Text(body)
                ],
              ),
            )),
      ),
    );
  }
}
