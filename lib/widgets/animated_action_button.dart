import 'package:material_ui/material_ui.dart';

class AnimatedActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color color;
  final Color glowColor;
  final double height;

  const AnimatedActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color = const Color(0xFF2563EB),
    this.glowColor = const Color(0xFF3B82F6),
    this.height = 54,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withAlpha(isPressed ? 70 : 110),
              blurRadius: isPressed ? 8 : 20,
              spreadRadius: isPressed ? 0 : 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.white.withAlpha(75),
            highlightColor: Colors.white.withAlpha(30),
            onTapDown: (_) {
              setState(() => isPressed = true);
            },
            onTapUp: (_) {
              setState(() => isPressed = false);
            },
            onTapCancel: () {
              setState(() => isPressed = false);
            },
            onTap: widget.onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
