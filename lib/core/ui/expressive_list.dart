import 'package:flutter/material.dart';

class ExpressiveList extends StatelessWidget {
  final int itemCount;
  final Widget Function(
    BuildContext context,
    int index,
    BorderRadius borderRadius,
  )
  itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double gap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ExpressiveList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.gap = 2.0,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding:
          padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: gap),
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final isLast = index == itemCount - 1;
        final isSingle = itemCount == 1;

        BorderRadius borderRadius;
        if (isSingle) {
          borderRadius = BorderRadius.circular(24);
        } else if (isFirst) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          );
        } else if (isLast) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          );
        } else {
          borderRadius = BorderRadius.circular(4);
        }

        return itemBuilder(context, index, borderRadius);
      },
    );
  }
}

class ExpressiveListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final List<Widget>? slidableActions;

  const ExpressiveListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.slidableActions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget tile = Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0,
        ),
        onTap: onTap,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );

    return tile;
  }
}
