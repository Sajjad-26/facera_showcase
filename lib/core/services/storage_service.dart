import 'dart:convert';
import 'package:facera_showcase/core/services/subscription_service.dart';
import 'package:facera_showcase/features/analysis/analysis_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyRecentScans = 'recent_scans';
  static const String _keyBestResult = 'best_result_v1';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Syncs data with cloud (Mocked)
  Future<void> syncData() async {
    await getBestResult();
  }

  Future<AnalysisResult> saveResult(AnalysisResult result) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> scans = prefs.getStringList(_keyRecentScans) ?? [];

    // --- NON-DECLINING SCORE LOGIC ---
    AnalysisResult finalResult = result;
    final AnalysisResult? bestResult = await getBestResult();

    if (bestResult != null) {
      // Merge: Take the HIGHER of each score for the "Best Result"
      finalResult = AnalysisResult(
        overallScore: (result.overallScore > bestResult.overallScore)
            ? result.overallScore
            : bestResult.overallScore,
        jawlineDefinition:
            (result.jawlineDefinition > bestResult.jawlineDefinition)
                ? result.jawlineDefinition
                : bestResult.jawlineDefinition,
        facialLeanness: (result.facialLeanness > bestResult.facialLeanness)
            ? result.facialLeanness
            : bestResult.facialLeanness,
        cheekbones: (result.cheekbones > bestResult.cheekbones)
            ? result.cheekbones
            : bestResult.cheekbones,
        symmetry: (result.symmetry > bestResult.symmetry)
            ? result.symmetry
            : bestResult.symmetry,
        masculinity: (result.masculinity > bestResult.masculinity)
            ? result.masculinity
            : bestResult.masculinity,
        faceShape: result.faceShape,
        auraRank: (result.overallScore > bestResult.overallScore)
            ? result.auraRank
            : bestResult.auraRank,
        potentialScore:
            (result.potentialScore ?? 0) > (bestResult.potentialScore ?? 0)
                ? result.potentialScore
                : bestResult.potentialScore,
        feedback: result.feedback,
        gonialAngle: result.gonialAngle,
        cheekToJawRatio: result.cheekToJawRatio,
        cheekboneDepth: result.cheekboneDepth,
        fwhr: result.fwhr,
        lowerFaceHeight: result.lowerFaceHeight,
        fatAdjustmentFactor: result.fatAdjustmentFactor,
        jawlineVisibility: result.jawlineVisibility,
        cheekType: result.cheekType,
        imagePath: result.imagePath,
        date: result.date,
      );
    }

    // Save the new High Water Mark locally
    await _saveBestResult(finalResult);

    // MOCK Cloud Sync (No-op)
    // FirestoreService().saveBestResult(...) -> Removed for showcase

    // Add result to history
    scans.insert(0, jsonEncode(finalResult.toJson()));

    // Enforce limits based on plan
    final plan = await getSubscriptionPlan();
    final int limit = (plan == 'pro_plus') ? 100 : 10;

    if (scans.length > limit) {
      scans = scans.sublist(0, limit);
    }

    await prefs.setStringList(_keyRecentScans, scans);
    await incrementScanCount();

    return finalResult;
  }

  Future<AnalysisResult?> getBestResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_keyBestResult);

    if (json == null) {
      // No cloud fallback in showcase
      return null;
    }

    try {
      return AnalysisResult.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveBestResult(AnalysisResult result) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBestResult, jsonEncode(result.toJson()));
  }

  Future<List<AnalysisResult>> getRecentScans() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scans = prefs.getStringList(_keyRecentScans) ?? [];

    return scans
        .map((e) {
          try {
            return AnalysisResult.fromJson(jsonDecode(e));
          } catch (e) {
            return null;
          }
        })
        .whereType<AnalysisResult>()
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentScans);
  }

  Future<void> clearBestResult() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBestResult);
  }

  // --- User Preferences ---
  static const String _keyUserGoal = 'user_goal';
  static const String _keyUserName = 'user_name';

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  Future<void> saveUserGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserGoal, goal);
  }

  Future<String?> getUserGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserGoal);
  }

  // --- Subscription & Usage Limits ---
  static const String _keyLastScanDate = 'last_scan_date';
  static const String _keyDailyScanCount = 'daily_scan_count';

  Future<String> getSubscriptionPlan() async {
    return await SubscriptionService().getCurrentPlan();
  }

  Future<bool> canScan() async {
    final plan = await SubscriptionService().forceRefresh();
    if (plan == 'pro_plus') return true;
    return false; // Mocked simple logic
  }

  Future<void> incrementScanCount() async {
    // Basic counter implementation
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyDailyScanCount) ?? 0;
    await prefs.setInt(_keyDailyScanCount, count + 1);
  }
}
