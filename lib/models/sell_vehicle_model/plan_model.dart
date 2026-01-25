class PlanModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final bool isActive;
  final List<PlanFeatureModel>? planFeatures;

  PlanModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.isActive,
    this.planFeatures,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      planFeatures: json['plan_features'] != null
          ? (json['plan_features'] as List)
              .map((e) => PlanFeatureModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class PlanFeatureModel {
  final int id;
  final FeatureModel feature;
  final String value;

  PlanFeatureModel({
    required this.id,
    required this.feature,
    required this.value,
  });

  factory PlanFeatureModel.fromJson(Map<String, dynamic> json) {
    return PlanFeatureModel(
      id: json['id'] as int,
      feature: FeatureModel.fromJson(json['feature'] as Map<String, dynamic>),
      value: json['value'] as String,
    );
  }
}

class FeatureModel {
  final int id;
  final String key;
  final String description;
  final int featureValueTypeId;

  FeatureModel({
    required this.id,
    required this.key,
    required this.description,
    required this.featureValueTypeId,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as int,
      key: json['key'] as String,
      description: json['description'] as String,
      featureValueTypeId: json['feature_value_type_id'] as int,
    );
  }
}
