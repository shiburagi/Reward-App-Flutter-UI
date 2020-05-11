import 'dart:math';

import 'package:flutter/material.dart';

typedef CollpaseWidgetBuilder = Widget Function(
    BuildContext context, double offset);

class SliverCollapseHeader extends SliverPersistentHeader {
  SliverCollapseHeader({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.builder,
  }) : super(
          pinned: true,
          floating: true,
          delegate: SliverCollapseHeaderDelegate(
              builder: builder, maxHeight: maxHeight, minHeight: minHeight),
        );

  final double minHeight;
  final double maxHeight;
  final CollpaseWidgetBuilder builder;
}

class SliverCollapseHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverCollapseHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.builder,
  });
  final double minHeight;
  final double maxHeight;
  final CollpaseWidgetBuilder builder;

  @override
  double get minExtent => this.minHeight;
  @override
  double get maxExtent => this.maxHeight;

  double offset = 0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double offset = shrinkOffset / (this.maxExtent - this.minExtent);
    return builder(context, min(1, offset));
  }

  @override
  bool shouldRebuild(SliverCollapseHeaderDelegate oldDelegate) {
    return false;
  }
}
