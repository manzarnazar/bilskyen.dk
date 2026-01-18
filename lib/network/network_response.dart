class NetworkResponse {
  bool success;
  String message;
  dynamic data;
  bool failed;
  NetworkResponse({
    this.data,
    this.failed = false,
    this.message = "",
    this.success = false,
  });

  @override
  String toString() => message;
}
