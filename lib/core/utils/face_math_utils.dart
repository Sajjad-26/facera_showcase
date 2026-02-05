import 'dart:math';

/// 3D point representation for face mesh landmarks
class Point3D {
  final double x;
  final double y;
  final double z;

  const Point3D(this.x, this.y, this.z);

  @override
  String toString() => 'Point3D($x, $y, $z)';
}

/// Mathematical utilities for facial geometry calculations
class FaceMathUtils {
  /// Calculate 3D Euclidean distance between two points
  static double distance3D(Point3D a, Point3D b) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    final dz = b.z - a.z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  /// Calculate 2D Euclidean distance (ignoring Z)
  static double distance2D(Point3D a, Point3D b) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    return sqrt(dx * dx + dy * dy);
  }

  /// Calculate angle at vertex B (in degrees) using Law of Cosines
  /// Returns angle ABC where B is the vertex
  static double angle3D(Point3D a, Point3D vertex, Point3D c) {
    // Vector from vertex to A
    final vaX = a.x - vertex.x;
    final vaY = a.y - vertex.y;
    final vaZ = a.z - vertex.z;

    // Vector from vertex to C
    final vcX = c.x - vertex.x;
    final vcY = c.y - vertex.y;
    final vcZ = c.z - vertex.z;

    // Dot product
    final dotProduct = vaX * vcX + vaY * vcY + vaZ * vcZ;

    // Magnitudes
    final magA = sqrt(vaX * vaX + vaY * vaY + vaZ * vaZ);
    final magC = sqrt(vcX * vcX + vcY * vcY + vcZ * vcZ);

    // Avoid division by zero
    if (magA == 0 || magC == 0) return 0;

    // Clamp to avoid floating point errors in acos
    final cosAngle = (dotProduct / (magA * magC)).clamp(-1.0, 1.0);

    // Convert to degrees
    return acos(cosAngle) * 180 / pi;
  }

  /// Map a value to a 1-10 score
  /// [value] - The measured value
  /// [idealMin], [idealMax] - The ideal range (gets score 10)
  /// [worstValue] - The worst possible value (gets score 1)
  static int mapToScore(
    double value,
    double idealMin,
    double idealMax,
    double worstValue,
  ) {
    // If within ideal range, return 10
    if (value >= idealMin && value <= idealMax) {
      return 10;
    }

    // Determine which direction the worst value is
    final bool worstIsHigher = worstValue > idealMax;

    double score;
    if (worstIsHigher) {
      // Higher values are worse
      if (value < idealMin) {
        // Below ideal - linear interpolation toward 7
        score = 10 - ((idealMin - value) / idealMin) * 3;
      } else {
        // Above ideal - linear interpolation toward worst
        final range = worstValue - idealMax;
        final distance = value - idealMax;
        score = 10 - (distance / range) * 9; // 10 -> 1
      }
    } else {
      // Lower values are worse
      if (value > idealMax) {
        // Above ideal - linear interpolation toward 7
        score = 10 - ((value - idealMax) / idealMax) * 3;
      } else {
        // Below ideal - linear interpolation toward worst
        final range = idealMin - worstValue;
        final distance = idealMin - value;
        score = 10 - (distance / range) * 9; // 10 -> 1
      }
    }

    return score.round().clamp(1, 9);
  }

  /// Calculate average Z depth for a list of points
  static double averageZ(List<Point3D> points) {
    if (points.isEmpty) return 0;
    return points.map((p) => p.z).reduce((a, b) => a + b) / points.length;
  }

  /// Calculate the midpoint between two 3D points
  static Point3D midpoint(Point3D a, Point3D b) {
    return Point3D((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2);
  }

  /// Calculate symmetry score from left/right landmark pairs
  /// Returns a score from 1-10, where 10 is perfect symmetry
  /// Checks BOTH horizontal distance from midline AND vertical alignment
  static int symmetryScore(List<(Point3D, Point3D, double)> pairs) {
    if (pairs.isEmpty) return 5;

    double totalXDifference = 0;
    double totalYDifference = 0;
    double totalWidth = 0;
    double totalHeight = 0;

    for (final (left, right, midlineX) in pairs) {
      // X-AXIS: Check horizontal distance from midline
      final leftDistanceX = (left.x - midlineX).abs();
      final rightDistanceX = (right.x - midlineX).abs();
      final xDifference = (leftDistanceX - rightDistanceX).abs();
      totalXDifference += xDifference;
      totalWidth += (leftDistanceX + rightDistanceX);

      // Y-AXIS: Check vertical alignment (are left and right at same height?)
      final yDifference = (left.y - right.y).abs();
      totalYDifference += yDifference;
      // Use the horizontal span as reference for Y normalization
      totalHeight += (leftDistanceX + rightDistanceX);
    }

    if (totalWidth == 0) return 5;

    // Calculate X asymmetry as percentage
    final xAsymmetryPercent = (totalXDifference / totalWidth) * 100;

    // Calculate Y asymmetry as percentage (vertical misalignment)
    final yAsymmetryPercent = (totalYDifference / totalHeight) * 100;

    // Combined asymmetry (weighted: X is more noticeable than Y)
    final combinedAsymmetry =
        (xAsymmetryPercent * 0.6) + (yAsymmetryPercent * 0.4);

    if (combinedAsymmetry <= 0.5) return 10;
    if (combinedAsymmetry <= 1.0) return 9;
    if (combinedAsymmetry <= 2.0) return 8;
    if (combinedAsymmetry <= 4.0) return 7;
    if (combinedAsymmetry <= 8.0) return 6;
    if (combinedAsymmetry <= 12.0) return 5;
    if (combinedAsymmetry <= 16.0) return 4;
    if (combinedAsymmetry <= 20) return 3;
    if (combinedAsymmetry <= 25) return 2;
    return 1;
  }

  /// Calculate fWHR (Facial Width-to-Height Ratio)
  static double calculateFWHR(
    Point3D leftCheek,
    Point3D rightCheek,
    Point3D eyebrowTop,
    Point3D upperLip,
  ) {
    final width = distance2D(leftCheek, rightCheek);
    final height = distance2D(eyebrowTop, upperLip);

    if (height == 0) return 1.8; // Default average

    return width / height;
  }

  /// Map fWHR to masculinity score (1-10)
  static int fwhrToMasculinityScore(double fwhr) {
    if (fwhr >= 2.2) return 9;
    if (fwhr >= 2.0) return 8;
    if (fwhr >= 1.9) return 7;
    if (fwhr >= 1.8) return 6;
    if (fwhr >= 1.7) return 5;
    if (fwhr >= 1.6) return 4;
    return 3;
  }

  /// Calculate cross product of two vectors (a and b)
  static Point3D crossProduct(Point3D a, Point3D b) {
    return Point3D(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x,
    );
  }

  /// Calculate dot product of two vectors
  static double dotProduct(Point3D a, Point3D b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
  }

  /// Calculate surface normal vector for a triangle defined by 3 points
  static Point3D calculateSurfaceNormal(Point3D p1, Point3D p2, Point3D p3) {
    // Vector U = p2 - p1
    final ux = p2.x - p1.x;
    final uy = p2.y - p1.y;
    final uz = p2.z - p1.z;

    // Vector V = p3 - p1
    final vx = p3.x - p1.x;
    final vy = p3.y - p1.y;
    final vz = p3.z - p1.z;

    final u = Point3D(ux, uy, uz);
    final v = Point3D(vx, vy, vz);

    final normal = crossProduct(u, v);
    final mag = sqrt(
      normal.x * normal.x + normal.y * normal.y + normal.z * normal.z,
    );

    if (mag == 0) return const Point3D(0, 0, 1);

    return Point3D(normal.x / mag, normal.y / mag, normal.z / mag);
  }

  /// Linear interpolation for biometric multipliers
  static double lerpMultiplier({
    required double value,
    required double minBound,
    required double maxBound,
    required double minMult,
    required double maxMult,
  }) {
    if (value <= minBound) return minMult;
    if (value >= maxBound) return maxMult;

    // Normalize value to 0..1 range
    final t = (value - minBound) / (maxBound - minBound);
    // Interpolate multipliers
    return minMult + (t * (maxMult - minMult));
  }

  /// Normalize a metric by Inter-pupillary Distance (IPD)
  static double normalizeByIPD(double value, double ipd) {
    if (ipd == 0) return value;
    // Standard IPD is ~63mm. We use it to scale the raw coordinates.
    const double standardIPD = 63.0; // Reference value
    return value * (standardIPD / ipd);
  }

  /// Calculate weighted Aura Score (0-100)
  static int calculateAuraScore({
    required int jawline,
    required int masculinity,
    required int symmetry,
    required int cheekbones,
    required int leanness,
  }) {
    final score = (jawline * 0.25) +
        (masculinity * 0.25) +
        (symmetry * 0.20) +
        (cheekbones * 0.15) +
        (leanness * 0.15);
    return (score * 10).round().clamp(0, 100);
  }

  /// Calculate potential score (if leanness were maxed out)
  static int? calculatePotentialScore({
    required int jawline,
    required int masculinity,
    required int symmetry,
    required int cheekbones,
    required int currentLeanness,
  }) {
    if (currentLeanness >= 7) return null; // No potential needed

    return calculateAuraScore(
      jawline: jawline,
      masculinity: masculinity,
      symmetry: symmetry,
      cheekbones: cheekbones,
      leanness: 10, // Max leanness
    );
  }
}
