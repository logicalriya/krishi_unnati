import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/disease_classifier_service.dart';
import '../../widgets/detection_result_widgets.dart';

class CropHealthPage extends StatefulWidget {
  const CropHealthPage({super.key});

  @override
  State<CropHealthPage> createState() => _CropHealthPageState();
}

class _CropHealthPageState extends State<CropHealthPage> {
  final ImagePicker picker = ImagePicker();
  final DiseaseClassifierService classifier = DiseaseClassifierService();

  XFile? selectedImage;

  List<Map<String, dynamic>> predictionResults = [];

  bool isPredicting = false;
  bool isModelLoading = true;

  bool _readScreenEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await classifier.loadModel();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load disease detection model: $e')),
      );
    } finally {
      if (mounted) setState(() => isModelLoading = false);
    }
  }

  @override
  void dispose() {
    classifier.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImage = image;
          predictionResults = [];
          isPredicting = true;
        });

        await _runPrediction(image);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not select image: $e',
          ),
        ),
      );
      setState(() => isPredicting = false);
    }
  }

  Future<void> _runPrediction(XFile image) async {
    if (kIsWeb) {
      setState(() {
        isPredicting = false;
        predictionResults = [];
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('On-device detection is not available on web.')),
      );
      return;
    }

    try {
      if (!classifier.isLoaded) {
        await classifier.loadModel();
      }

      final predictions = await classifier.predict(File(image.path));
      final top = predictions.take(2).toList();

      setState(() {
        predictionResults = top.map((p) {
          final isHealthy = p.diseaseName.toLowerCase().contains('healthy');
          return {
            'diseaseName': _formatLabel(p.diseaseName),
            'rawLabel': p.diseaseName,
            'probability': '${(p.probability * 100).toStringAsFixed(2)}%',
            'highRisk': !isHealthy && p.probability > 0.6,
          };
        }).toList();
        isPredicting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isPredicting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prediction failed: $e')),
      );
    }
  }

  String _formatLabel(String raw) {
    return raw.replaceAll('___', ' ').replaceAll('__', ' ').replaceAll('_', ' ');
  }

  // ============================================================
  // SYMPTOMS DIALOG
  // ============================================================

  void showSymptomsDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Describe Symptoms', style: TextStyle(fontSize: 18)),
          content: TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Example: Yellow spots on leaves...',
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                if (controller.text.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Symptoms submitted.')),
                  );
                }
              },
              child: const Text('Submit', style: TextStyle(fontSize: 14)),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ASK EXPERTS QUERY
  // ============================================================

  void _handleExpertQuery(String query) {
    // TODO: send `query` to your backend / expert chat feature.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Query submitted: "$query"')),
    );
  }

  // ============================================================
  // READ SCREEN BAR
  // ============================================================

  Widget _buildReadScreenBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F1F3),
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E5EA),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.hearing, size: 22, color: Color(0xFF17375E)),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'READ SCREEN',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF26303A)),
              ),
              SizedBox(height: 2),
              Text(
                'ASSISTANCE TOOLS',
                style: TextStyle(fontSize: 10, letterSpacing: .4, color: Color(0xFF6C7075)),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.volume_up_outlined, size: 20, color: Color(0xFF596069)),
          const SizedBox(width: 6),
          Switch(
            value: _readScreenEnabled,
            onChanged: (value) {
              setState(() => _readScreenEnabled = value);
              // TODO: hook up actual screen-reading (e.g. flutter_tts) here.
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: const Color(0xFF0BA951),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SELECTED IMAGE PREVIEW
  // ============================================================

  Widget selectedImageWidget() {
    if (selectedImage == null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFE7F3E8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.image,
          size: 48,
          color: Colors.grey,
        ),
      );
    }

    if (kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          selectedImage!.path,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(selectedImage!.path),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Leaf Disease Detection',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF297A4A),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            _buildReadScreenBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  children: [
                    if (isModelLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Loading detection model...',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),

                    // ==================================================
                    // UPLOAD CARD
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              selectedImageWidget(),
                              if (selectedImage != null)
                                Positioned(
                                  right: -8,
                                  top: -8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = null;
                                        predictionResults = [];
                                        isPredicting = false;
                                      });
                                    },
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Upload Leaf Photo',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Select a photo from gallery or capture using camera',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // GALLERY BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: isModelLoading
                                  ? null
                                  : () {
                                pickImage(ImageSource.gallery);
                              },
                              icon: const Icon(Icons.upload, size: 20),
                              label: const Text(
                                'Choose from Gallery',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // CAMERA BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: isModelLoading
                                  ? null
                                  : () {
                                pickImage(ImageSource.camera);
                              },
                              icon: const Icon(Icons.camera_alt_outlined, size: 20),
                              label: const Text(
                                'Capture with Camera',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // VOICE SYMPTOMS BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: showSymptomsDialog,
                              icon: const Icon(
                                Icons.mic_none,
                                size: 20,
                                color: Colors.grey,
                              ),
                              label: const Text(
                                'Describe Symptoms (Voice)',
                                style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFD9D9D9)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (isPredicting)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(
                          color: Color(0xFF16A34A),
                        ),
                      ),

                    // ==================================================
                    // DETECTION RESULTS + FAQ + ASK EXPERTS
                    // ==================================================

                    if (!isPredicting && predictionResults.isNotEmpty) ...[
                      DetectionResultsHeader(matchCount: predictionResults.length),
                      const SizedBox(height: 10),
                      ...predictionResults.map(
                            (result) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DiseaseResultCard(
                            diseaseName: result['diseaseName'] ?? 'Unknown Disease',
                            rawLabel: result['rawLabel'] ?? '',
                            probability: result['probability'] ?? '--',
                            highRisk: result['highRisk'] ?? false,
                          ),
                        ),
                      ),
                      FaqButton(
                        onTap: () {
                          // TODO: navigate to your FAQ page/screen
                        },
                      ),
                      AskExpertsSection(onSubmit: _handleExpertQuery),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}