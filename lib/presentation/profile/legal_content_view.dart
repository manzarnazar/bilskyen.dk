import 'package:bilskyen/gen_l10n/app_localizations.dart';
import 'package:bilskyen/models/legal_content_model/legal_content_model.dart';
import 'package:bilskyen/repositories/legal/legal_repository.dart';
import 'package:bilskyen/utils/app_colors.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LegalPageType { privacy, terms }

class LegalContentView extends StatefulWidget {
  final LegalPageType pageType;

  const LegalContentView({
    super.key,
    required this.pageType,
  });

  @override
  State<LegalContentView> createState() => _LegalContentViewState();
}

class _LegalContentViewState extends State<LegalContentView> {
  final LegalRepository _legalRepository = LegalRepository();
  late Future<Either<String, LegalContentModel>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _loadContent();
  }

  Future<Either<String, LegalContentModel>> _loadContent() {
    if (widget.pageType == LegalPageType.privacy) {
      return _legalRepository.getPrivacyPolicy();
    }
    return _legalRepository.getTermsOfService();
  }

  void _retry() {
    setState(() {
      _contentFuture = _loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageType == LegalPageType.privacy
              ? l10n.privacyPolicyTitle
              : l10n.termsOfService,
        ),
      ),
      body: FutureBuilder<Either<String, LegalContentModel>>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return _ErrorState(
              message: l10n.error,
              onRetry: _retry,
            );
          }

          return snapshot.data!.fold(
            (error) => _ErrorState(
              message: error,
              onRetry: _retry,
            ),
            (content) {
              if (content.isEmpty) {
                return _EmptyState(
                  message: l10n.info,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: content.orderedSections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final section = content.orderedSections[index];
                  return _LegalSectionCard(
                    title: _formatSectionTitle(section.key),
                    body: _sanitizeContent(section.value),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  static String _formatSectionTitle(String key) {
    // Hide generic CMS body keys from UI (e.g., privacy_body / terms_body).
    if (key.toLowerCase().endsWith('_body')) {
      return '';
    }

    final words = key
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (words.isEmpty) return '';

    return words
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  static String _sanitizeContent(String input) {
    var content = input;
    content = content.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    content = content.replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n\n');
    content = content.replaceAll(RegExp(r'<[^>]*>'), '');
    content = content
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    return content.trim();
  }
}

class _LegalSectionCard extends StatelessWidget {
  final String title;
  final String body;

  const _LegalSectionCard({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
          ],
          SelectableText(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
