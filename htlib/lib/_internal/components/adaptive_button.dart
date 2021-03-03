part of 'adaptive_scaffold.dart';

class AdaptiveButton extends StatefulWidget {
  final AdaptiveScaffoldDestination destination;
  final bool selected;
  final Function() onTap;

  const AdaptiveButton({Key key, this.destination, this.selected, this.onTap})
      : super(key: key);
  @override
  _AdaptiveButtonState createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton> {
  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    MaterialStateProperty<Color> backgroundColor;
    MaterialStateProperty<Color> overlayColor;
    MaterialStateProperty<Color> shadowColor;
    MaterialStateProperty<Color> foregroundColor;

    if (isInit == false) {
      backgroundColor = MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (widget.selected) return Theme.of(context).primaryColor;

          return Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).tileColor;
        },
      );

      overlayColor = (!widget.selected)
          ? MaterialStateProperty.resolveWith<Color>((states) {
              return Theme.of(context).colorScheme.secondary.withOpacity(0.1);
            })
          : null;

      shadowColor = MaterialStateProperty.all<Color>(
        (!widget.selected)
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.8)
            : Theme.of(context).colorScheme.primary.withOpacity(0.8),
      );

      foregroundColor = MaterialStateProperty.resolveWith(
        (states) {
          if (widget.selected) return Theme.of(context).colorScheme.onPrimary;

          if (states.isEmpty)
            return Color.lerp(
              Colors.white,
              Theme.of(context).colorScheme.secondary,
              0.8,
            );
          return Theme.of(context).primaryColor;
        },
      );
      isInit = false;
    }

    if (!PageBreak.defaultPB.isDesktop(context)) {
      return SizedBox(
        height: 60 - Insets.xs,
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: backgroundColor,
            overlayColor: overlayColor,
            foregroundColor: foregroundColor,
            shadowColor: shadowColor,
          ),
          onPressed: widget.onTap,
          child: Row(
            mainAxisAlignment: PageBreak.defaultPB.isDesktop(context)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (PageBreak.defaultPB.isDesktop(context)) HSpace(1.0),
              Icon(widget.destination.icon),
              if (PageBreak.defaultPB.isDesktop(context)) ...[
                HSpace(Insets.xl),
                Text(widget.destination.title),
              ],
            ],
          ),
        ),
      ).padding(
        top: Insets.m,
        horizontal: PageBreak.defaultPB.isDesktop(context) ? Insets.m : 8.0,
      );
    } else {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: backgroundColor,
          overlayColor: overlayColor,
          foregroundColor: foregroundColor,
          shadowColor: shadowColor,
        ),
        onPressed: widget.onTap,
        child: Row(
          mainAxisAlignment: PageBreak.defaultPB.isDesktop(context)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (PageBreak.defaultPB.isDesktop(context)) HSpace(1.0),
            Icon(widget.destination.icon),
            if (PageBreak.defaultPB.isDesktop(context)) ...[
              HSpace(Insets.xl),
              Text(
                widget.destination.title,
              ),
            ],
          ],
        ),
      ).constrained(height: 60 - Insets.xs, width: double.infinity).padding(
            top: Insets.m,
            horizontal: PageBreak.defaultPB.isDesktop(context) ? Insets.m : 8.0,
          );
    }
  }
}
