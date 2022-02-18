import 'package:flutter/material.dart';
import 'package:snakegame/direction.dart';
import 'package:snakegame/page/gamepage.dart';

class ControlPanal extends StatelessWidget {
  const ControlPanal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ControlButton(
              icon: Icon(Icons.chevron_left), direction: Direction.left),
          const SizedBox(
            width: 20.0,
          ),
          Column(
            children: const [
              ControlButton(
                  icon: Icon(Icons.keyboard_arrow_up),
                  direction: Direction.top),
              SizedBox(
                height: 30.0,
              ),
              ControlButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  direction: Direction.bottom),
            ],
          ),
          const SizedBox(
            width: 20.0,
          ),
          const ControlButton(
              icon: Icon(Icons.chevron_right), direction: Direction.right),
        ],
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final Icon icon;
  final Direction direction;
  const ControlButton({Key? key, required this.icon, required this.direction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: 60.0,
        height: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              GamePage.direction = this.direction;
            },
            child: icon,
          ),
        ),
      ),
    );
  }
}
