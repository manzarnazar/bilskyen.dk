class SellVehicleRequestModel {
  final String registration;
  final String? vin;
  final String? title;
  final int price;
  final int fuelTypeId;
  final int kmDriven;
  final int? variantId;
  final String? variantName;
  final int? colorId;
  final int? euronomId;
  final String? euronomName;
  final int? firstRegistrationMonth;
  final int? firstRegistrationYear;
  final int? lastInspectionMonth;
  final int? lastInspectionYear;
  final double? fuelEfficiency;
  final int? technicalTotalWeight;
  final List<int>? equipmentIds;
  final String? servicebog; // 'Yes', 'No', 'Default'
  final String? description;
  final String sellerPhone;
  final String sellerAddress;
  final String sellerPostcode;
  final int? planId;
  final String? vehicleExternalId;
  final int? brandId;
  final int? modelId;
  final int? modelYearId;
  final int? categoryId;
  final int? listingTypeId;
  final int? typeId;
  final String? typeName;
  final int? useId;
  final int? bodyTypeId;
  final int? gearTypeId;
  final int? enginePower;
  final int? towingWeight;
  final int? ownershipTax;
  final String? firstRegistrationDate;
  final String? version;
  final int vehicleListStatusId;
  final String? publishedAt;

  SellVehicleRequestModel({
    required this.registration,
    this.vin,
    this.title,
    required this.price,
    required this.fuelTypeId,
    required this.kmDriven,
    this.variantId,
    this.variantName,
    this.colorId,
    this.euronomId,
    this.euronomName,
    this.firstRegistrationMonth,
    this.firstRegistrationYear,
    this.lastInspectionMonth,
    this.lastInspectionYear,
    this.fuelEfficiency,
    this.technicalTotalWeight,
    this.equipmentIds,
    this.servicebog,
    this.description,
    required this.sellerPhone,
    required this.sellerAddress,
    required this.sellerPostcode,
    this.planId,
    this.vehicleExternalId,
    this.brandId,
    this.modelId,
    this.modelYearId,
    this.categoryId,
    this.listingTypeId,
    this.typeId,
    this.typeName,
    this.useId,
    this.bodyTypeId,
    this.gearTypeId,
    this.enginePower,
    this.towingWeight,
    this.ownershipTax,
    this.firstRegistrationDate,
    this.version,
    required this.vehicleListStatusId,
    this.publishedAt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'registration': registration,
      'price': price,
      'fuel_type_id': fuelTypeId,
      'km_driven': kmDriven,
      'seller_phone': sellerPhone,
      'seller_address': sellerAddress,
      'seller_postcode': sellerPostcode,
      'vehicle_list_status_id': vehicleListStatusId,
    };

    if (vin != null) json['vin'] = vin;
    if (title != null) json['title'] = title;
    if (variantId != null) json['variant_id'] = variantId;
    if (variantName != null) json['variant_name'] = variantName;
    if (colorId != null) json['color_id'] = colorId;
    if (euronomId != null) json['euronom_id'] = euronomId;
    if (euronomName != null) json['euronom_name'] = euronomName;
    if (firstRegistrationMonth != null)
      json['first_registration_month'] = firstRegistrationMonth;
    if (firstRegistrationYear != null)
      json['first_registration_year'] = firstRegistrationYear;
    if (lastInspectionMonth != null)
      json['last_inspection_month'] = lastInspectionMonth;
    if (lastInspectionYear != null)
      json['last_inspection_year'] = lastInspectionYear;
    if (fuelEfficiency != null) json['fuel_efficiency'] = fuelEfficiency;
    if (technicalTotalWeight != null)
      json['technical_total_weight'] = technicalTotalWeight;
    if (equipmentIds != null && equipmentIds!.isNotEmpty)
      json['equipment_ids'] = equipmentIds;
    if (servicebog != null) json['servicebog'] = servicebog;
    if (description != null) json['description'] = description;
    if (planId != null) json['plan_id'] = planId;
    if (vehicleExternalId != null)
      json['vehicle_external_id'] = vehicleExternalId;
    if (brandId != null) json['brand_id'] = brandId;
    if (modelId != null) json['model_id'] = modelId;
    if (modelYearId != null) json['model_year_id'] = modelYearId;
    if (categoryId != null) json['category_id'] = categoryId;
    if (listingTypeId != null) json['listing_type_id'] = listingTypeId;
    if (typeId != null) json['type_id'] = typeId;
    if (typeName != null) json['type_name'] = typeName;
    if (useId != null) json['use_id'] = useId;
    if (bodyTypeId != null) json['body_type_id'] = bodyTypeId;
    if (gearTypeId != null) json['gear_type_id'] = gearTypeId;
    if (enginePower != null) json['engine_power'] = enginePower;
    if (towingWeight != null) json['towing_weight'] = towingWeight;
    if (ownershipTax != null) json['ownership_tax'] = ownershipTax;
    if (firstRegistrationDate != null)
      json['first_registration_date'] = firstRegistrationDate;
    if (version != null) json['version'] = version;
    if (publishedAt != null) json['published_at'] = publishedAt;

    return json;
  }
}
