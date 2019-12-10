library rebuild_stats;

import 'dart:async';
import 'package:flutter/widgets.dart';

class Profiler {
  Profiler({
    this.watchedWidgets = const <String>[],
  })  : _streamController = StreamController(),
        _statCounts = Map.fromIterable(
          watchedWidgets,
          key: (widget) => widget,
          value: (widget) => 0,
        );

  final List<String> watchedWidgets;
  final StreamController<Stat> _streamController;
  final Map<String, int> _statCounts;

  void profile() {
    assert(debugOnRebuildDirtyWidget == null);

    debugOnRebuildDirtyWidget = _onRebuildWidget;
    _streamController.stream.listen((stat) => _statCounts[stat.widget]++);
  }

  void _onRebuildWidget(Element element, bool onceBuilt) {
    final widget = element.widget;
    if (!watchedWidgets.contains(widget.runtimeType.toString())) {
      return;
    }

    _streamController.sink.add(Stat(
      widget: widget.runtimeType.toString(),
    ));
  }
}

class Stat {
  const Stat({
    this.widget,
  });

  final String widget;
}
