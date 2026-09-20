import 'package:flutter/material.dart';

/// Breakpoints for responsive layout
class Breakpoints {
  static const mobile = 600.0;
  static const tablet = 900.0;
  static const desktop = 1200.0;
}

enum ScreenType { mobile, tablet, desktop, largeDesktop }

class Responsive {
  static ScreenType getType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) return ScreenType.mobile;
    if (width < Breakpoints.tablet) return ScreenType.tablet;
    if (width < Breakpoints.desktop) return ScreenType.desktop;
    return ScreenType.largeDesktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < Breakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= Breakpoints.mobile && w < Breakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.tablet;

  /// Grid columns for module cards: 2 on mobile, 3 on tablet, 4 on desktop
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) return 2;
    if (width < Breakpoints.tablet) return 3;
    if (width < Breakpoints.desktop) return 4;
    return 5;
  }

  /// Max content width so things don't stretch edge-to-edge on wide screens
  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) return width;
    if (width < Breakpoints.desktop) return 700;
    return 900;
  }

  /// For exam screen: two-column layout (question | options) on wide screens
  static bool useTwoColumnExam(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.tablet;

  /// Horizontal page padding that scales with screen size
  static double pagePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) return 16;
    if (width < Breakpoints.desktop) return 32;
    return 48;
  }
}

/// Wraps content with a centered, max-width constrained container,
/// sized to the child's natural height. Use this for header bars,
/// nav bars, or any row/column that should NOT stretch vertically
/// (e.g. inside a Column as a non-Expanded child).
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  const ResponsiveCenter({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? Responsive.maxContentWidth(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}

/// Same as ResponsiveCenter, but fills all available space first.
/// Use this when the child contains Expanded/Column that needs a
/// bounded height to work — e.g. as the direct child of Scaffold.body
/// or inside an Expanded widget in a parent Column.
class ResponsiveCenterExpand extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  const ResponsiveCenterExpand({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? Responsive.maxContentWidth(context);
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: child,
        ),
      ),
    );
  }
}
