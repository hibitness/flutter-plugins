import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/services.dart';

class NoiseEvent {
  NoiseEvent(this.decibel);

  final num decibel;

  @override
  String toString() {
    return "[Decibel Reading: $decibel dB]";
  }
}

NoiseEvent _noiseEvent(num decibel) {
  return new NoiseEvent(decibel);
}

class Noise {
  Noise(this._path, this._frequency);

  String _path;
  int _frequency;

  static const MethodChannel _noiseMethodChannel =
      const MethodChannel('noise.methodChannel');
  static const EventChannel _noiseEventChannel =
      EventChannel('noise.eventChannel');

  Stream<NoiseEvent> _noiseStream;

  Stream<NoiseEvent> get noiseStream {
    Map<String, dynamic> args = {'path': _path, 'frequency': '$_frequency'};
    if (_noiseStream == null) {
      _noiseStream = _noiseEventChannel
          .receiveBroadcastStream(args)
          .map((db) => _noiseEvent(db));
    }
    return _noiseStream;
  }

}
