import 'package:bilskyen/config/api_config.dart';
import 'package:bilskyen/models/legal_content_model/legal_content_model.dart';
import 'package:bilskyen/network/network_repository.dart';
import 'package:dartz/dartz.dart';

class LegalRepository {
  final networkRepository = NetworkRepository();

  Future<Either<String, LegalContentModel>> getPrivacyPolicy() async {
    return _fetchLegalContent(ApiConfig.privacyPolicy);
  }

  Future<Either<String, LegalContentModel>> getTermsOfService() async {
    return _fetchLegalContent(ApiConfig.termsOfService);
  }

  Future<Either<String, LegalContentModel>> _fetchLegalContent(String endpoint) async {
    final response = await networkRepository.get(url: endpoint);

    if (!response.failed && response.success) {
      try {
        final root = response.data as Map<String, dynamic>;
        final data = root['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final legalContent = LegalContentModel.fromJson(data);
        return right(legalContent);
      } catch (e) {
        return left('Failed to parse legal content: $e');
      }
    }

    return left(response.message.isNotEmpty ? response.message : 'Failed to load content');
  }
}
