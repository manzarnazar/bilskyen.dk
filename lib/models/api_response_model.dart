class ApiResponse<T> {
  final T data;

  ApiResponse({
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': toJsonT(data),
    };
  }
}

class PaginatedResponse<T> {
  final List<T> docs;
  final int limit;
  final int page;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;
  final int? totalDocs;
  final int? totalPages;

  PaginatedResponse({
    required this.docs,
    required this.limit,
    required this.page,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
    this.totalDocs,
    this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      docs: (json['docs'] as List).map((item) => fromJsonT(item)).toList(),
      limit: json['limit'] as int,
      page: json['page'] as int,
      hasPrevPage: json['hasPrevPage'] as bool,
      hasNextPage: json['hasNextPage'] as bool,
      prevPage: json['prevPage'] as int?,
      nextPage: json['nextPage'] as int?,
      totalDocs: json['totalDocs'] as int?,
      totalPages: json['totalPages'] as int?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'docs': docs.map((item) => toJsonT(item)).toList(),
      'limit': limit,
      'page': page,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
      'prevPage': prevPage,
      'nextPage': nextPage,
      'totalDocs': totalDocs,
      'totalPages': totalPages,
    };
  }
}

class ErrorResponse {
  final String status;
  final String message;
  final Map<String, List<String>>? errors;

  ErrorResponse({
    required this.status,
    required this.message,
    this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              (json['errors'] as Map).map(
                (key, value) => MapEntry(
                  key as String,
                  List<String>.from(value as List),
                ),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (errors != null) 'errors': errors,
    };
  }
}

