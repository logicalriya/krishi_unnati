import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:flutter_litert/flutter_litert.dart';

class DiseasePrediction {
  final String diseaseName;
  final double probability; // 0.0 - 1.0

  DiseasePrediction({required this.diseaseName, required this.probability});
}

class DiseaseClassifierService {
  static const String _modelPath = 'assets/pest_model/pest_model_float32.tflite';
  static const String _labelsPath = 'assets/pest_model/labels.txt';
  static const int _inputSize = 224;
  static final int _resizeTarget = (224 * 1.14).round();

  // Must match your PyTorch training transforms.Normalize(...) exactly.
  static const List<double> _mean = [0.485, 0.456, 0.406];
  static const List<double> _std = [0.229, 0.224, 0.225];

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool get isLoaded => _interpreter != null;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelPath);

    final labelsRaw = await rootBundle.loadString(_labelsPath);
    _labels = labelsRaw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Runs inference on [imageFile] and returns predictions sorted by
  /// probability, highest first.
  Future<List<DiseasePrediction>> predict(File imageFile) async {
    if (_interpreter == null) {
      throw StateError('Model not loaded. Call loadModel() first.');
    }

    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('Could not decode image');
    }

    // Resize shorter side to 256, then center-crop to 224x224 —
    // matches torchvision transforms.Resize(256) + CenterCrop(224).
    final resized = _resizeShorterSideToTarget(decoded, _resizeTarget);
    final cropped = _centerCrop(resized, _inputSize);

    // Build input tensor: [1, 224, 224, 3], normalized float32, NHWC layout.
    final input = List.generate(
      1,
          (_) => List.generate(
        _inputSize,
            (y) => List.generate(
          _inputSize,
              (x) {
            final pixel = cropped.getPixel(x, y);
            return [
              (pixel.r / 255.0 - _mean[0]) / _std[0],
              (pixel.g / 255.0 - _mean[1]) / _std[1],
              (pixel.b / 255.0 - _mean[2]) / _std[2],
            ];
          },
        ),
      ),
    );

    // Output tensor: [1, numClasses]
    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter!.run(input, output);

    final logits = output[0];
    final probabilities = _softmax(logits);

    final predictions = List.generate(
      _labels.length,
          (i) => DiseasePrediction(diseaseName: _labels[i], probability: probabilities[i]),
    );

    predictions.sort((a, b) => b.probability.compareTo(a.probability));
    return predictions;
  }

  img.Image _resizeShorterSideToTarget(img.Image src, int targetSize) {
    final shortSide = min(src.width, src.height);
    final scale = targetSize / shortSide;
    return img.copyResize(
      src,
      width: (src.width * scale).round(),
      height: (src.height * scale).round(),
    );
  }

  img.Image _centerCrop(img.Image src, int size) {
    final left = ((src.width - size) / 2).round();
    final top = ((src.height - size) / 2).round();
    return img.copyCrop(src, x: left, y: top, width: size, height: size);
  }

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(max);
    final exps = logits.map((l) => exp(l - maxLogit)).toList();
    final sumExps = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExps).toList();
  }

  void dispose() {
    _interpreter?.close();
  }
}