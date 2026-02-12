class SellerStatisticsModel {
  final int totalVehicles;
  final int totalWorth;
  final int totalInquiries;
  final int totalViews;
  final SellerStatisticsByStatus? byStatus;

  SellerStatisticsModel({
    required this.totalVehicles,
    required this.totalWorth,
    required this.totalInquiries,
    required this.totalViews,
    this.byStatus,
  });

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory SellerStatisticsModel.fromJson(Map<String, dynamic> json) {
    final byStatusJson = json['by_status'] as Map<String, dynamic>?;
    return SellerStatisticsModel(
      totalVehicles: _parseInt(json['total_vehicles']),
      totalWorth: _parseInt(json['total_worth']),
      totalInquiries: _parseInt(json['total_inquiries']),
      totalViews: _parseInt(json['total_views']),
      byStatus: byStatusJson != null
          ? SellerStatisticsByStatus.fromJson(byStatusJson)
          : null,
    );
  }
}

class SellerStatisticsByStatus {
  final int published;
  final int draft;
  final int sold;
  final int archived;

  SellerStatisticsByStatus({
    required this.published,
    required this.draft,
    required this.sold,
    required this.archived,
  });

  factory SellerStatisticsByStatus.fromJson(Map<String, dynamic> json) {
    return SellerStatisticsByStatus(
      published: SellerStatisticsModel._parseInt(json['published']),
      draft: SellerStatisticsModel._parseInt(json['draft']),
      sold: SellerStatisticsModel._parseInt(json['sold']),
      archived: SellerStatisticsModel._parseInt(json['archived']),
    );
  }
}
