import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final double? x, y, size;
  bool isAnimation;
  Color color;
  Piece(
      {Key? key,
      this.x,
      this.y,
      this.size,
      required this.color,
      this.isAnimation = false})
      : super(key: key);

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimation == true) {
      animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      );
      animation = Tween(begin: 0.23, end: 1.0).animate(animationController!);

      animationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController!.forward();
        }
      });
      animationController!.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isAnimation) {
      animationController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(animation!.value.toString());
    return Positioned(
      left: widget.x,
      top: widget.y,
      child: Opacity(
        opacity: (widget.isAnimation) ? animation!.value : 1.0,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            border: Border.all(
              color: Colors.black38,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
