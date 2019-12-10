library rebuild_stats;

import 'dart:async';
import 'package:flutter/widgets.dart';

class Profiler {
  Profiler({
    this.watchedWidgets = const <String>[],
  })  : _streamController = StreamController(),
        _statCounts = {};

  final List<String> watchedWidgets;
  final StreamController<Stat> _streamController;
  final Map<String, int> _statCounts;

  void profile() {
    assert(debugOnRebuildDirtyWidget == null);

    debugOnRebuildDirtyWidget = _onRebuildWidget;
    _streamController.stream.listen(_onListenStat);
  }

  void _onRebuildWidget(Element element, bool onceBuilt) {
    final widget = element.widget;
    if (!watchedWidgets.contains(widget.runtimeType.toString())) {
      return;
    }

    _streamController.sink.add(Stat(
      widget: RebuiltWidget.from(widget),
    ));
  }

  void _onListenStat(Stat stat) {
    _statCounts[stat.widget.toString()] ??= 0;
    _statCounts[stat.widget.toString()]++;
    print(_statCounts);
  }
}

class Stat {
  const Stat({
    this.widget,
  });

  final RebuiltWidget widget;
}

class RebuiltWidget {
  const RebuiltWidget({
    this.runtimeType,
    this.key,
  });

  factory RebuiltWidget.from(Widget widget) {
    return RebuiltWidget(
      runtimeType: widget.runtimeType,
      key: widget.key,
    );
  }

  final Type runtimeType;
  final Key key;

  @override
  String toString() {
    return '${runtimeType.toString()}(${key.toString()})';
  }
}
