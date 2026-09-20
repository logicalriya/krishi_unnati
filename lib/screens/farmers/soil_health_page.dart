import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SoilHealthPage extends StatefulWidget {
  const SoilHealthPage({super.key});

  @override
  State<SoilHealthPage> createState() => _SoilHealthPageState();
}

class _SoilHealthPageState extends State<SoilHealthPage> {
  // ── Agriculture theme ────────────────────────────────────────
  static const _green = Color(0xFF2E7D32);
  static const _greenDark = Color(0xFF1B5E20);
  static const _greenLight = Color(0xFFE8F3E8);
  static const _greenSurface = Color(0xFFF4F8F3);
  static const _greenBorder = Color(0xFFCFE3CF);
  static const _text = Color(0xFF17321C);
  static const _muted = Color(0xFF607064);

  String? selectedFileName;

  final List<Map<String, TextEditingController>> fertilizers = [
    {
      'name': TextEditingController(),
      'quantity': TextEditingController(),
      'date': TextEditingController(),
    }
  ];

  Future<void> pickSoilCard() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  void addFertilizer() {
    setState(() {
      fertilizers.add({
        'name': TextEditingController(),
        'quantity': TextEditingController(),
        'date': TextEditingController(),
      });
    });
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text =
          '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.year}';
    }
  }

  @override
  void dispose() {
    for (final fertilizer in fertilizers) {
      fertilizer['name']!.dispose();
      fertilizer['quantity']!.dispose();
      fertilizer['date']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _greenSurface,

      // ---------------- HEADER ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Soil Health Analysis',
          style: TextStyle(
            color: _greenDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: _greenDark,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Column(
            children: [

              // ================= SOIL CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _greenBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _greenDark.withOpacity(0.06),
                      blurRadius: 9,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: const [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: _greenDark,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Upload Your Soil Health Card',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _text,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Upload your government-issued soil health card\n'
                      'for quick analysis',
                      style: TextStyle(
                        fontSize: 9,
                        height: 1.4,
                        color: _muted,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // -------- UPLOAD BOX --------
                    GestureDetector(
                      onTap: pickSoilCard,
                      child: Container(
                        width: double.infinity,
                        height: 76,
                        decoration: BoxDecoration(
                          color: _greenSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _greenBorder,
                            width: 1,
                          ),
                        ),
                        child: CustomPaint(
                          painter: DashedBorderPainter(),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 21,
                                  color: _greenDark,
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  selectedFileName ??
                                      'Drag & drop or select file',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: selectedFileName != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _text,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 2),

                                const Text(
                                  'Supported: JPG, PNG, PDF (Max 5MB)',
                                  style: TextStyle(
                                    fontSize: 7,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ================= FERTILIZER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _greenBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _greenDark.withOpacity(0.05),
                      blurRadius: 9,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 17,
                          color: _greenDark,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Fertilizer Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _text,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Fertilizer entries
                    ...fertilizers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final fertilizer = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: _greenSurface,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: _greenBorder,
                            ),
                          ),
                          child: Column(
                            children: [

                              // Fertilizer name
                              _buildTextField(
                                controller: fertilizer['name']!,
                                hint: 'Fertilizer Name (e.g., Urea, DAP, NPK)',
                              ),

                              const SizedBox(height: 6),

                              // Quantity
                              _buildTextField(
                                controller: fertilizer['quantity']!,
                                hint: 'Quantity (e.g., 50 kg)',
                              ),

                              const SizedBox(height: 6),

                              // Date
                              TextField(
                                controller: fertilizer['date'],
                                readOnly: true,
                                onTap: () => selectDate(
                                  context,
                                  fertilizer['date']!,
                                ),
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: _text,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Application Date (dd-mm-yyyy)',
                                  hintStyle: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF8A968D),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 8,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 15,
                                    color: _greenDark,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: _greenBorder,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: _greenBorder,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: _green,
                                      width: 1.3,
                                    ),
                                  ),
                                ),
                              ),

                              // Remove fertilizer
                              if (index > 0)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        fertilizers[index]['name']!
                                            .dispose();
                                        fertilizers[index]['quantity']!
                                            .dispose();
                                        fertilizers[index]['date']!
                                            .dispose();
                                        fertilizers.removeAt(index);
                                      });
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFFC62828),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // -------- ADD FERTILIZER --------
                    Center(
                      child: TextButton.icon(
                        onPressed: addFertilizer,
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 15,
                          color: _green,
                        ),
                        label: const Text(
                          'Add More Fertilizer',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: _greenDark,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ================= SUBMIT =================
              SizedBox(
                width: double.infinity,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your soil analysis API logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: _greenDark,
                        content: Text(
                          'Soil analysis submitted successfully',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Submit Analysis',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 9,
        color: _text,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 9,
          color: Color(0xFF8A968D),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: _greenBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: _greenBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: _green,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}


// ============================================================
// DASHED BORDER
// ============================================================

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8CAF91)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;

    final path = Path();

    // Top
    double x = 0;
    while (x < size.width) {
      path.moveTo(x, 0);
      path.lineTo(
        (x + dashWidth).clamp(0, size.width),
        0,
      );
      x += dashWidth + dashSpace;
    }

    // Bottom
    x = 0;
    while (x < size.width) {
      path.moveTo(x, size.height);
      path.lineTo(
        (x + dashWidth).clamp(0, size.width),
        size.height,
      );
      x += dashWidth + dashSpace;
    }

    // Left
    double y = 0;
    while (y < size.height) {
      path.moveTo(0, y);
      path.lineTo(
        0,
        (y + dashWidth).clamp(0, size.height),
      );
      y += dashWidth + dashSpace;
    }

    // Right
    y = 0;
    while (y < size.height) {
      path.moveTo(size.width, y);
      path.lineTo(
        size.width,
        (y + dashWidth).clamp(0, size.height),
      );
      y += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}