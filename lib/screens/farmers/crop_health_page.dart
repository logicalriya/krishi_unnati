import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CropHealthPage extends StatefulWidget {
  const CropHealthPage({super.key});

  @override
  State<CropHealthPage> createState() => _CropHealthPageState();
}

class _CropHealthPageState extends State<CropHealthPage> {
  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;

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
        });

        // Later:
        // Send selectedImage to the AI disease detection model.
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
    }
  }

  // ============================================================
  // SYMPTOMS DIALOG
  // ============================================================

  void showSymptomsDialog() {
    final TextEditingController controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Describe Symptoms',
          ),

          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'Example: Yellow spots on leaves...',
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                if (controller.text.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Symptoms submitted.',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Submit',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SELECTED IMAGE PREVIEW
  // ============================================================

  Widget selectedImageWidget() {
    if (selectedImage == null) {
      return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFE7F3E8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image,
          size: 30,
          color: Colors.grey,
        ),
      );
    }

    // Web image preview
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          selectedImage!.path,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      );
    }

    // Android / iOS image preview
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(selectedImage!.path),
        width: 70,
        height: 70,
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

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xFF263238),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Leaf Disease Detection',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF297A4A),
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            10,
            12,
            10,
            20,
          ),
          child: Column(
            children: [

              // ==================================================
              // UPLOAD CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    // ==========================================
                    // IMAGE PREVIEW
                    // ==========================================

                    Stack(
                      clipBehavior: Clip.none,
                      children: [

                        selectedImageWidget(),

                        if (selectedImage != null)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage = null;
                                });
                              },

                              child: Container(
                                width: 18,
                                height: 18,
                                decoration:
                                    const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 11,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ==========================================
                    // TITLE
                    // ==========================================

                    const Text(
                      'Upload Leaf Photo',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'Select a photo from gallery or capture using camera',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==========================================
                    // GALLERY BUTTON
                    // ==========================================

                    SizedBox(
                      width: double.infinity,
                      height: 28,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          pickImage(
                            ImageSource.gallery,
                          );
                        },

                        icon: const Icon(
                          Icons.upload,
                          size: 13,
                        ),

                        label: const Text(
                          'Choose from Gallery',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ==========================================
                    // CAMERA BUTTON
                    // ==========================================

                    SizedBox(
                      width: double.infinity,
                      height: 28,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          pickImage(
                            ImageSource.camera,
                          );
                        },

                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 13,
                        ),

                        label: const Text(
                          'Capture with Camera',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ==========================================
                    // VOICE SYMPTOMS BUTTON
                    // ==========================================

                    SizedBox(
                      width: double.infinity,
                      height: 28,

                      child: OutlinedButton.icon(
                        onPressed: showSymptomsDialog,

                        icon: const Icon(
                          Icons.mic_none,
                          size: 13,
                          color: Colors.grey,
                        ),

                        label: const Text(
                          'Describe Symptoms (Voice)',
                          style: TextStyle(
                            fontSize: 8,
                            color: Color(0xFF555555),
                          ),
                        ),

                        style:
                            OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFD9D9D9),
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 7),

              // ==================================================
              // DISEASE RESULT 1
              // ==================================================

              DiseaseResultCard(
                diseaseName:
                    'Cotton Curl Virus',
                probability:
                    '96.91%',
                description:
                    'Tap to see details',
                highRisk: true,
              ),

              const SizedBox(height: 7),

              // ==================================================
              // DISEASE RESULT 2
              // ==================================================

              DiseaseResultCard(
                diseaseName:
                    'Cotton Fusarium Wilt',
                probability:
                    '0.53%',
                description:
                    'Tap to see details',
                highRisk: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DISEASE RESULT CARD
// ============================================================

class DiseaseResultCard extends StatelessWidget {
  final String diseaseName;
  final String probability;
  final String description;
  final bool highRisk;

  const DiseaseResultCard({
    super.key,
    required this.diseaseName,
    required this.probability,
    required this.description,
    required this.highRisk,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,

          builder: (context) {
            return AlertDialog(
              title: Text(
                diseaseName,
              ),

              content: Text(
                'AI detection confidence: '
                '$probability\n\n'
                'More detailed information about '
                'this disease will be displayed here later.',
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    'Close',
                  ),
                ),
              ],
            );
          },
        );
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
            ),
          ],
        ),

        child: Row(
          children: [

            // ================================================
            // LEAF ICON
            // ================================================

            const Icon(
              Icons.eco_outlined,
              size: 17,
              color: Color(0xFF20A963),
            ),

            const SizedBox(width: 6),

            // ================================================
            // DISEASE INFORMATION
            // ================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    diseaseName,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // ================================================
            // PROBABILITY
            // ================================================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),

              decoration: BoxDecoration(
                color: highRisk
                    ? const Color(0xFFE8F8EF)
                    : const Color(0xFFE8F8EF),

                borderRadius:
                    BorderRadius.circular(10),
              ),

              child: Text(
                'Possibility: $probability',

                style: const TextStyle(
                  fontSize: 6.5,
                  color: Color(0xFF18894F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}