import 'dart:io';

/// Validation utilities for form validation and data formatting
class ValidationUtils {
  /// Maximum image size in bytes (20MB)
  static const int maxImageSizeBytes = 20 * 1024 * 1024;

  /// Valid image mime types
  static const List<String> validImageMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/jpg',
    'image/gif',
  ];

  /// Valid image file extensions
  static const List<String> validImageExtensions = [
    '.jpeg',
    '.png',
    '.jpg',
    '.gif',
  ];

  /// Validates image file size (max 20MB)
  /// Returns error message if invalid, null if valid
  static String? validateImageSize(File file) {
    try {
      final fileSize = file.lengthSync();
      if (fileSize > maxImageSizeBytes) {
        final sizeInMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
        return 'Image size ($sizeInMB MB) exceeds maximum allowed size of 20 MB';
      }
      return null;
    } catch (e) {
      return 'Unable to read image file: ${e.toString()}';
    }
  }

  /// Validates image file type
  /// Returns error message if invalid, null if valid
  static String? validateImageType(File file) {
    try {
      final extension = file.path.toLowerCase();
      final hasValidExtension = validImageExtensions.any(
        (ext) => extension.endsWith(ext),
      );

      if (!hasValidExtension) {
        return 'Invalid image type. Allowed types: JPEG, PNG, JPG, GIF';
      }
      return null;
    } catch (e) {
      return 'Unable to validate image type: ${e.toString()}';
    }
  }

  /// Validates a list of image files
  /// Returns list of error messages, empty if all valid
  static List<String> validateImages(List<File> images) {
    final errors = <String>[];
    for (var i = 0; i < images.length; i++) {
      final file = images[i];
      final sizeError = validateImageSize(file);
      if (sizeError != null) {
        errors.add('Image ${i + 1}: $sizeError');
      }
      final typeError = validateImageType(file);
      if (typeError != null) {
        errors.add('Image ${i + 1}: $typeError');
      }
    }
    return errors;
  }

  /// Formats date from month and year to ISO date string (YYYY-MM-DD)
  /// Uses first day of the month if both month and year are provided
  /// Returns null if either month or year is missing
  static String? formatDateFromMonthYear(int? month, int? year) {
    if (month == null || year == null) {
      return null;
    }

    // Validate month range
    if (month < 1 || month > 12) {
      return null;
    }

    // Validate year range (reasonable bounds)
    if (year < 1900 || year > 2100) {
      return null;
    }

    try {
      final date = DateTime(year, month, 1);
      return date.toIso8601String().split('T')[0]; // Returns YYYY-MM-DD
    } catch (e) {
      return null;
    }
  }

  /// Validates string max length
  /// Returns error message if invalid, null if valid
  static String? validateStringMaxLength(String? value, int maxLength) {
    if (value == null) {
      return null; // Null values are handled separately
    }
    if (value.length > maxLength) {
      return 'Maximum length is $maxLength characters (current: ${value.length})';
    }
    return null;
  }

  /// Validates that a string is not empty
  /// Returns error message if invalid, null if valid
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates integer is non-negative
  /// Returns error message if invalid, null if valid
  static String? validateNonNegativeInteger(int? value, String fieldName) {
    if (value == null) {
      return null; // Null values are handled separately
    }
    if (value < 0) {
      return '$fieldName must be a positive number';
    }
    return null;
  }

  /// Validates integer is positive (greater than 0)
  /// Returns error message if invalid, null if valid
  static String? validatePositiveInteger(int? value, String fieldName) {
    if (value == null) {
      return null; // Null values are handled separately
    }
    if (value <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  /// Validates VIN format (max 17 characters)
  static String? validateVin(String? vin) {
    if (vin == null || vin.isEmpty) {
      return null; // VIN is optional
    }
    if (vin.length > 17) {
      return 'VIN must be maximum 17 characters (current: ${vin.length})';
    }
    return null;
  }

  /// Validates registration format (max 20 characters)
  static String? validateRegistration(String? registration) {
    if (registration == null || registration.isEmpty) {
      return 'Registration number is required';
    }
    if (registration.length > 20) {
      return 'Registration number must be maximum 20 characters (current: ${registration.length})';
    }
    return null;
  }

  /// Validates title format (required, max 255 characters)
  static String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title is required';
    }
    if (title.length > 255) {
      return 'Title must be maximum 255 characters (current: ${title.length})';
    }
    return null;
  }
}
