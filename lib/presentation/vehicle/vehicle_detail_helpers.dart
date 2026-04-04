import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../models/vehicle_detail_model/vehicle_detail_model.dart';

String formatPriceKr(int price) {
  final priceStr = price.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < priceStr.length; i++) {
    if (i > 0 && (priceStr.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(priceStr[i]);
  }
  return '${buffer.toString()} kr.';
}

String formatKrDouble(double? v, {int fractionDigits = 0}) {
  if (v == null) return '';
  final fmt = intl.NumberFormat('#,##0${fractionDigits > 0 ? '.${'#' * fractionDigits}' : ''}', 'da_DK');
  return '${fmt.format(v)} kr.';
}

String _commaGroupUnsignedInt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) {
      buf.write(',');
    }
    buf.write(s[i]);
  }
  return buf.toString();
}

String _phpStyleNumber(double amount, int decimals) {
  final neg = amount < 0;
  final a = neg ? -amount : amount;
  if (decimals == 0) {
    final n = a.round();
    return '${neg ? '-' : ''}${_commaGroupUnsignedInt(n)}';
  }
  final s = a.toStringAsFixed(decimals);
  final dot = s.indexOf('.');
  final intPart = int.parse(s.substring(0, dot));
  final fracPart = s.substring(dot + 1);
  return '${neg ? '-' : ''}${_commaGroupUnsignedInt(intPart)}.$fracPart';
}

String _rtrimTrailingZerosAndDot(String s) {
  if (!s.contains('.')) return s;
  return s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// Mirrors Laravel [FormatHelper::formatCurrency] DKK branch (dot decimal, comma thousands).
String formatCurrencyDkk(double? amount) {
  if (amount == null) return 'N/A';
  final hasDecimals = amount != amount.floorToDouble();
  final formatted = hasDecimals
      ? _rtrimTrailingZerosAndDot(_phpStyleNumber(amount, 2))
      : _phpStyleNumber(amount, 0);
  return '$formatted kr.';
}

/// Parses API `annual_tax` string for [formatCurrencyDkk].
double? parseAnnualTaxAmount(String? raw) {
  if (raw == null) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  final direct = double.tryParse(t);
  if (direct != null) return direct;
  return double.tryParse(t.replaceAll(',', ''));
}

String formatDate(BuildContext context, String? dateString) {
  if (dateString == null || dateString.isEmpty) return '';
  try {
    final date = DateTime.parse(dateString);
    final locale = Localizations.localeOf(context).toString();
    return intl.DateFormat('MMMM d, y', locale).format(date);
  } catch (_) {
    return dateString;
  }
}

String formatDaysAgo(BuildContext context, String? dateString, AppLocalizations l10n) {
  if (dateString == null || dateString.isEmpty) return '';
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);
    final days = difference.inDays;
    if (days == 0) {
      return l10n.today;
    } else if (days == 1) {
      return l10n.oneDayAgo;
    } else {
      return l10n.daysAgo(days);
    }
  } catch (_) {
    return dateString;
  }
}

String formatMileage(int? mileage) {
  if (mileage == null) return '';
  final mileageStr = mileage.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < mileageStr.length; i++) {
    if (i > 0 && (mileageStr.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(mileageStr[i]);
  }
  return '${buffer.toString()} km';
}

/// Blade `vehicle-detail.blade.php` km_per_liter labeling (fuel_type_id).
({String label, String value})? kmEfficiencyDisplay(
  AppLocalizations l10n,
  VehicleDetailModel v,
) {
  final raw = v.kmPerLiter;
  if (raw == null || raw == 0) return null;
  final fid = v.fuelTypeId;
  const electric = {3, 7};
  const hybrid = {4, 5};
  if (fid != null && electric.contains(fid)) {
    return (
      label: l10n.electricRange,
      value: '${intl.NumberFormat('#,##0', 'da_DK').format(raw)} km',
    );
  }
  if (fid != null && hybrid.contains(fid)) {
    return (
      label: l10n.electricRangeOrKmPerL,
      value: '${intl.NumberFormat('#0.00', 'da_DK').format(raw)} km',
    );
  }
  return (
    label: l10n.fuelEfficiency,
    value: '${intl.NumberFormat('#0.00', 'da_DK').format(raw)} km/l',
  );
}

bool hasLeasingSection(VehicleDetailModel v) {
  if (v.leasingEnabled == true) return true;
  if (v.leasingType != null && v.leasingType!.isNotEmpty) return true;
  if (v.leasingCustomerType != null && v.leasingCustomerType!.isNotEmpty) {
    return true;
  }
  bool has(dynamic x) => x != null && x.toString().isNotEmpty;
  return has(v.leasingMonthlyPayment) ||
      has(v.leasingFirstPayment) ||
      has(v.leasingResidualValue) ||
      has(v.leasingDuration) ||
      has(v.leasingAnnualMileage) ||
      has(v.leasingTotalCost);
}

bool hasDealerPricingSection(VehicleDetailModel v) {
  bool has(dynamic x) => x != null && x.toString().isNotEmpty;
  return has(v.wholesalePrice) ||
      has(v.internalCostPrice) ||
      has(v.priceWithoutTax) ||
      v.wholesalePriceIncludesDelivery != null;
}

/// Blade `vehicle-detail.blade.php` Condition & History section `@if` (~535).
bool hasConditionHistorySection(VehicleDetailModel v) {
  bool nonEmpty(String? s) => s != null && s.trim().isNotEmpty;
  if (nonEmpty(v.description)) return true;
  if (nonEmpty(v.categoryName)) return true;
  if (nonEmpty(v.useName)) return true;
  if (nonEmpty(v.priceTypeName)) return true;
  if (nonEmpty(v.conditionName)) return true;
  if (v.servicebog != null &&
      v.servicebog!.isNotEmpty &&
      v.servicebog != 'Default') {
    return true;
  }
  if (nonEmpty(v.sellerPhone)) return true;
  if (nonEmpty(v.address) || nonEmpty(v.postcode)) return true;
  return false;
}
