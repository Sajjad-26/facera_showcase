import 'dart:io';
import 'dart:math';

/// Exception thrown when no face is detected (Mocked)
class NoFaceDetectedException implements Exception {
  final String message;
  NoFaceDetectedException([this.message = "No face detected in the image."]);
  @override
  String toString() => message;
}

/// Result of facial analysis using 3D mesh geometry
class AnalysisResult {
  final int overallScore; // 0-100 weighted Aura Score
  final int jawlineDefinition; // 1-10
  final int facialLeanness; // 1-10
  final int cheekbones; // 1-10
  final int symmetry; // 1-10
  final int masculinity; // 1-10
  final String faceShape;
  final String auraRank;
  final int? potentialScore;
  final List<String> feedback;
  final DateTime date;

  // Raw metrics
  final double? gonialAngle;
  final double? cheekToJawRatio;
  final double? cheekboneDepth;
  final double? fwhr;
  final double? lowerFaceHeight;

  // Soft tissue metrics
  final double? fatAdjustmentFactor;
  final String? jawlineVisibility;
  final String? cheekType;

  final String? imagePath;

  AnalysisResult({
    required this.overallScore,
    required this.jawlineDefinition,
    required this.facialLeanness,
    required this.cheekbones,
    required this.symmetry,
    required this.masculinity,
    required this.faceShape,
    required this.auraRank,
    this.potentialScore,
    required this.feedback,
    this.gonialAngle,
    this.cheekToJawRatio,
    this.cheekboneDepth,
    this.fwhr,
    this.lowerFaceHeight,
    this.fatAdjustmentFactor,
    this.jawlineVisibility,
    this.cheekType,
    this.imagePath,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'overallScore': overallScore,
        'jawlineDefinition': jawlineDefinition,
        'facialLeanness': facialLeanness,
        'cheekbones': cheekbones,
        'symmetry': symmetry,
        'masculinity': masculinity,
        'faceShape': faceShape,
        'auraRank': auraRank,
        'potentialScore': potentialScore,
        'feedback': feedback,
        'gonialAngle': gonialAngle,
        'cheekToJawRatio': cheekToJawRatio,
        'cheekboneDepth': cheekboneDepth,
        'fwhr': fwhr,
        'lowerFaceHeight': lowerFaceHeight,
        'fatAdjustmentFactor': fatAdjustmentFactor,
        'jawlineVisibility': jawlineVisibility,
        'cheekType': cheekType,
        'imagePath': imagePath,
        'date': date.toIso8601String(),
      };

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    int normalizeScore(dynamic value) {
      if (value == null) return 5;
      int score = value is int ? value : (value as num).toInt();
      if (score > 10) return (score / 10).round().clamp(1, 10);
      return score.clamp(1, 10);
    }

    final overallScore = json['overallScore'] ?? 0;

    return AnalysisResult(
      overallScore: overallScore,
      jawlineDefinition: normalizeScore(json['jawlineDefinition']),
      facialLeanness: normalizeScore(json['facialLeanness']),
      cheekbones: normalizeScore(json['cheekbones']),
      symmetry: normalizeScore(json['symmetry']),
      masculinity: normalizeScore(json['masculinity']),
      faceShape: json['faceShape'] ?? 'Unknown',
      auraRank: json['auraRank'] ?? _getAuraRank(overallScore),
      potentialScore: json['potentialScore'],
      feedback: List<String>.from(json['feedback'] ?? []),
      gonialAngle: json['gonialAngle']?.toDouble(),
      cheekToJawRatio: json['cheekToJawRatio']?.toDouble(),
      cheekboneDepth: json['cheekboneDepth']?.toDouble(),
      fwhr: json['fwhr']?.toDouble(),
      lowerFaceHeight: json['lowerFaceHeight']?.toDouble(),
      fatAdjustmentFactor: json['fatAdjustmentFactor']?.toDouble(),
      jawlineVisibility: json['jawlineVisibility'],
      cheekType: json['cheekType'],
      imagePath: json['imagePath'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  static String _getAuraRank(int score) {
    if (score >= 95) return "Legend / God Tier";
    if (score >= 85) return "Elite / Ethereal";
    if (score >= 70) return "High Tier";
    if (score >= 50) return "Above Average";
    return "Potential to Grow";
  }
}

/// MOCK Analysis Service
/// Replaces the complex ML Kit analysis for the public showcase.
class AnalysisService {
  static final AnalysisService _instance = AnalysisService._internal();
  factory AnalysisService() => _instance;
  AnalysisService._internal();

  /// Legacy 2D Analysis (Mocked)
  Future<AnalysisResult> analyzeImage(File image) async {
    // Simulate ML processing time
    await Future.delayed(const Duration(seconds: 3));

    // Return a mocked high-tier result for demonstration
    return _generateMockResult(image.path);
  }

  /// New 3D Volumetric Analysis (Mocked)
  Future<AnalysisResult> analyzeVolumetricScan({
    required dynamic front, // Dynamic to avoid FaceMesh dependency
    required dynamic left,
    required dynamic right,
    required dynamic up,
    required File previewImage,
  }) async {
    // Simulate ML processing time
    await Future.delayed(const Duration(seconds: 4));

    // verify parity check (Mocked)
    if (Random().nextBool() == false && 1 == 2) {
      // low chance of failure/liveness check mock
      throw NoFaceDetectedException("Liveness check failed (Mock).");
    }

    return _generateMockResult(previewImage.path);
  }

  AnalysisResult _generateMockResult(String imagePath) {
    const overallScore = 88;

    return AnalysisResult(
      overallScore: overallScore,
      jawlineDefinition: 9,
      facialLeanness: 8,
      cheekbones: 9,
      symmetry: 8,
      masculinity: 9,
      faceShape: "Diamond",
      auraRank: "Elite / Ethereal",
      potentialScore: 96,
      feedback: [
        "Sharp jawline detected.",
        "Prominent cheekbones visible.",
        "Excellent facial symmetry.",
        "Low body fat percentage estimated."
      ],
      gonialAngle: 122.5,
      cheekToJawRatio: 1.18,
      cheekboneDepth: 2.5,
      fwhr: 1.95,
      lowerFaceHeight: 0.7,
      fatAdjustmentFactor: 1.05,
      jawlineVisibility: "High",
      cheekType: "Hollow",
      imagePath: imagePath,
    );
  }
}
