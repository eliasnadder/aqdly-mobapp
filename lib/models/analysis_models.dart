class AnalyzedClause {
  final String text;
  final String predictedTypeClause;
  final String typeDisplayName;
  final String predictedRiskLevel;
  final String riskDisplayName;
  final String warning;
  final String? sectionTitle;
  final String? description;
  final String? recommendation;

  const AnalyzedClause({
    required this.text,
    required this.predictedTypeClause,
    required this.typeDisplayName,
    required this.predictedRiskLevel,
    required this.riskDisplayName,
    this.warning = '',
    this.sectionTitle,
    this.description,
    this.recommendation,
  });

  factory AnalyzedClause.fromJson(Map<String, dynamic> json) {
    return AnalyzedClause(
      text: json['text'] as String? ?? '',
      predictedTypeClause: json['predicted_type_clause'] as String? ?? '',
      typeDisplayName: json['type_display_name'] as String? ?? '',
      predictedRiskLevel: json['predicted_risk_level'] as String? ?? '',
      riskDisplayName: json['risk_display_name'] as String? ?? '',
      warning: json['warning'] as String? ?? '',
      sectionTitle: json['section_title'] as String?,
      description: json['description'] as String?,
      recommendation: json['recommendation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'predicted_type_clause': predictedTypeClause,
      'type_display_name': typeDisplayName,
      'predicted_risk_level': predictedRiskLevel,
      'risk_display_name': riskDisplayName,
      'warning': warning,
      if (sectionTitle != null) 'section_title': sectionTitle,
      if (description != null) 'description': description,
      if (recommendation != null) 'recommendation': recommendation,
    };
  }

  // Convenience getters for backward compatibility
  String get riskLevel => predictedRiskLevel;
  String get title => sectionTitle ?? typeDisplayName;
}

class AnalysisStats {
  final int totalClauses;
  final int highRiskClauses;
  final int mediumRiskClauses;
  final int lowRiskClauses;
  final Map<String, int> typeDistribution;

  const AnalysisStats({
    required this.totalClauses,
    required this.highRiskClauses,
    required this.mediumRiskClauses,
    required this.lowRiskClauses,
    required this.typeDistribution,
  });

  factory AnalysisStats.fromJson(Map<String, dynamic> json) {
    final Map<String, int> typeDist = {};
    if (json['type_distribution'] is Map) {
      (json['type_distribution'] as Map).forEach((key, value) {
        typeDist[key as String] = (value as num).toInt();
      });
    }

    return AnalysisStats(
      totalClauses: (json['total_clauses'] as num?)?.toInt() ?? 0,
      highRiskClauses: (json['high_risk_clauses'] as num?)?.toInt() ?? 0,
      mediumRiskClauses: (json['medium_risk_clauses'] as num?)?.toInt() ?? 0,
      lowRiskClauses: (json['low_risk_clauses'] as num?)?.toInt() ?? 0,
      typeDistribution: typeDist,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_clauses': totalClauses,
      'high_risk_clauses': highRiskClauses,
      'medium_risk_clauses': mediumRiskClauses,
      'low_risk_clauses': lowRiskClauses,
      'type_distribution': typeDistribution,
    };
  }

  // Convenience getters
  int get highRisk => highRiskClauses;
  int get mediumRisk => mediumRiskClauses;
  int get lowRisk => lowRiskClauses;
}

class AnalysisResult {
  final String filename;
  final bool isScanned;
  final List<AnalyzedClause> clauses;
  final String summary;
  final AnalysisStats stats;
  final ContractSummary? contractSummary;

  const AnalysisResult({
    required this.filename,
    required this.isScanned,
    required this.clauses,
    required this.summary,
    required this.stats,
    this.contractSummary,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    final List<AnalyzedClause> clauseList = [];
    if (json['clauses'] is List) {
      for (final item in json['clauses'] as List) {
        if (item is Map<String, dynamic>) {
          clauseList.add(AnalyzedClause.fromJson(item));
        }
      }
    }

    ContractSummary? contractSummary;
    if (json['summary'] is Map) {
      contractSummary = ContractSummary.fromJson(json['summary'] as Map<String, dynamic>);
    } else if (json['contract_summary'] is Map) {
      contractSummary = ContractSummary.fromJson(json['contract_summary'] as Map<String, dynamic>);
    }

    return AnalysisResult(
      filename: json['filename'] as String? ?? '',
      isScanned: json['is_scanned'] as bool? ?? false,
      clauses: clauseList,
      summary: json['summary'] is String ? json['summary'] as String : '',
      stats: json['stats'] != null
          ? AnalysisStats.fromJson(json['stats'] as Map<String, dynamic>)
          : const AnalysisStats(
              totalClauses: 0,
              highRiskClauses: 0,
              mediumRiskClauses: 0,
              lowRiskClauses: 0,
              typeDistribution: {},
            ),
      contractSummary: contractSummary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'is_scanned': isScanned,
      'clauses': clauses.map((c) => c.toJson()).toList(),
      'summary': summary,
      'stats': stats.toJson(),
      if (contractSummary != null) 'contract_summary': contractSummary!.toJson(),
    };
  }

  // Convenience getter for compliance score
  int get complianceScore => contractSummary?.complianceScore ?? _computeComplianceScore();

  int _computeComplianceScore() {
    if (stats.totalClauses == 0) return 100;
    final total = stats.totalClauses;
    final highWeight = 3;
    final mediumWeight = 2;
    final lowWeight = 1;
    final penalty = (stats.highRisk * highWeight + stats.mediumRisk * mediumWeight + stats.lowRisk * lowWeight);
    final maxPenalty = total * highWeight;
    return ((1 - penalty / maxPenalty) * 100).round().clamp(0, 100);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalysisResult &&
        other.filename == filename &&
        other.isScanned == isScanned &&
        other.summary == summary &&
        other.stats == stats &&
        _listEquals(other.clauses, clauses);
  }

  @override
  int get hashCode {
    return Object.hash(filename, isScanned, summary, stats, Object.hashAll(clauses));
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  AnalysisResult copyWith({
    String? filename,
    bool? isScanned,
    List<AnalyzedClause>? clauses,
    String? summary,
    AnalysisStats? stats,
  }) {
    return AnalysisResult(
      filename: filename ?? this.filename,
      isScanned: isScanned ?? this.isScanned,
      clauses: clauses ?? this.clauses,
      summary: summary ?? this.summary,
      stats: stats ?? this.stats,
    );
  }
}

class ContractSummary {
  final String filename;
  final int totalClauses;
  final int highRiskClauses;
  final int mediumRiskClauses;
  final int lowRiskClauses;
  final Map<String, int> typeDistribution;
  final int complianceScore;

  const ContractSummary({
    required this.filename,
    required this.totalClauses,
    required this.highRiskClauses,
    required this.mediumRiskClauses,
    required this.lowRiskClauses,
    required this.typeDistribution,
    required this.complianceScore,
  });

  factory ContractSummary.fromJson(Map<String, dynamic> json) {
    final Map<String, int> typeDist = {};
    if (json['type_distribution'] is Map) {
      (json['type_distribution'] as Map).forEach((key, value) {
        typeDist[key as String] = (value as num).toInt();
      });
    }

    return ContractSummary(
      filename: json['filename'] as String? ?? '',
      totalClauses: (json['total_clauses'] as num?)?.toInt() ?? 0,
      highRiskClauses: (json['high_risk_clauses'] as num?)?.toInt() ?? 0,
      mediumRiskClauses: (json['medium_risk_clauses'] as num?)?.toInt() ?? 0,
      lowRiskClauses: (json['low_risk_clauses'] as num?)?.toInt() ?? 0,
      typeDistribution: typeDist,
      complianceScore: (json['compliance_score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'total_clauses': totalClauses,
      'high_risk_clauses': highRiskClauses,
      'medium_risk_clauses': mediumRiskClauses,
      'low_risk_clauses': lowRiskClauses,
      'type_distribution': typeDistribution,
      'compliance_score': complianceScore,
    };
  }
}

class ContractDifference {
  final String type;
  final String message;
  final String impact;
  final String? clauseType;
  final ChangeDetail? changeDetail;

  const ContractDifference({
    required this.type,
    required this.message,
    required this.impact,
    this.clauseType,
    this.changeDetail,
  });

  factory ContractDifference.fromJson(Map<String, dynamic> json) {
    return ContractDifference(
      type: json['type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      impact: json['impact'] as String? ?? '',
      clauseType: json['clause_type'] as String?,
      changeDetail: json['change_detail'] != null
          ? ChangeDetail.fromJson(json['change_detail'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'impact': impact,
      if (clauseType != null) 'clause_type': clauseType,
      if (changeDetail != null) 'change_detail': changeDetail!.toJson(),
    };
  }

  // Legacy getter for backward compatibility
  String get description => message;
}

class ChangeDetail {
  final String contract1Value;
  final String contract2Value;

  const ChangeDetail({
    required this.contract1Value,
    required this.contract2Value,
  });

  factory ChangeDetail.fromJson(Map<String, dynamic> json) {
    return ChangeDetail(
      contract1Value: json['contract1_value'] as String? ?? '',
      contract2Value: json['contract2_value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contract1_value': contract1Value,
      'contract2_value': contract2Value,
    };
  }
}

class ComparisonResult {
  final ContractSummary contract1Summary;
  final ContractSummary contract2Summary;
  final List<ContractDifference> differences;
  final String summary;

  const ComparisonResult({
    required this.contract1Summary,
    required this.contract2Summary,
    required this.differences,
    required this.summary,
  });

  // Convenience getters matching the UI expectations
  ContractSummary get contract1 => contract1Summary;
  ContractSummary get contract2 => contract2Summary;

  factory ComparisonResult.fromJson(Map<String, dynamic> json) {
    final List<ContractDifference> diffList = [];
    if (json['differences'] is List) {
      for (final item in json['differences'] as List) {
        if (item is Map<String, dynamic>) {
          diffList.add(ContractDifference.fromJson(item));
        }
      }
    }

    return ComparisonResult(
      contract1Summary: json['contract1_summary'] != null
          ? ContractSummary.fromJson(json['contract1_summary'] as Map<String, dynamic>)
          : const ContractSummary(
              filename: '',
              totalClauses: 0,
              highRiskClauses: 0,
              mediumRiskClauses: 0,
              lowRiskClauses: 0,
              typeDistribution: {},
              complianceScore: 0,
            ),
      contract2Summary: json['contract2_summary'] != null
          ? ContractSummary.fromJson(json['contract2_summary'] as Map<String, dynamic>)
          : const ContractSummary(
              filename: '',
              totalClauses: 0,
              highRiskClauses: 0,
              mediumRiskClauses: 0,
              lowRiskClauses: 0,
              typeDistribution: {},
              complianceScore: 0,
            ),
      differences: diffList,
      summary: json['summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contract1_summary': contract1Summary.toJson(),
      'contract2_summary': contract2Summary.toJson(),
      'differences': differences.map((d) => d.toJson()).toList(),
    };
  }
}

class RagIngestResponse {
  final String sessionId;
  final int clausesCount;

  const RagIngestResponse({
    required this.sessionId,
    required this.clausesCount,
  });

  factory RagIngestResponse.fromJson(Map<String, dynamic> json) {
    return RagIngestResponse(
      sessionId: json['session_id'] as String? ?? '',
      clausesCount: (json['clauses_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'clauses_count': clausesCount,
    };
  }
}

class RetrievedClause {
  final int clauseIndex;
  final String parentText;
  final double score;

  const RetrievedClause({
    required this.clauseIndex,
    required this.parentText,
    required this.score,
  });

  factory RetrievedClause.fromJson(Map<String, dynamic> json) {
    return RetrievedClause(
      clauseIndex: (json['clause_index'] as num?)?.toInt() ?? 0,
      parentText: json['parent_text'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clause_index': clauseIndex,
      'parent_text': parentText,
      'score': score,
    };
  }
}

class RagAnswer {
  final String answer;
  final List<RetrievedClause> retrievedClauses;
  final String sessionId;

  const RagAnswer({
    required this.answer,
    required this.retrievedClauses,
    required this.sessionId,
  });

  factory RagAnswer.fromJson(Map<String, dynamic> json) {
    final List<RetrievedClause> clauses = [];
    if (json['retrieved_clauses'] is List) {
      for (final item in json['retrieved_clauses'] as List) {
        if (item is Map<String, dynamic>) {
          clauses.add(RetrievedClause.fromJson(item));
        }
      }
    }

    return RagAnswer(
      answer: json['answer'] as String? ?? '',
      retrievedClauses: clauses,
      sessionId: json['session_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'retrieved_clauses': retrievedClauses.map((c) => c.toJson()).toList(),
      'session_id': sessionId,
    };
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final List<RetrievedClause> sources;
  final DateTime sentAt;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.sources,
    required this.sentAt,
  });

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    List<RetrievedClause>? sources,
    DateTime? sentAt,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      sources: sources ?? this.sources,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}

class HistoryEntry {
  final String id;
  final DateTime savedAt;
  final AnalysisResult result;

  const HistoryEntry({
    required this.id,
    required this.savedAt,
    required this.result,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String? ?? '',
      savedAt: json['saved_at'] is String
          ? DateTime.parse(json['saved_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(
              (json['saved_at'] as num?)?.toInt() ?? 0, isUtc: true),
      result: json['result'] != null
          ? AnalysisResult.fromJson(json['result'] as Map<String, dynamic>)
          : const AnalysisResult(
              filename: '',
              isScanned: false,
              clauses: [],
              summary: '',
              stats: AnalysisStats(
                totalClauses: 0,
                highRiskClauses: 0,
                mediumRiskClauses: 0,
                lowRiskClauses: 0,
                typeDistribution: {},
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saved_at': savedAt.toIso8601String(),
      'result': result.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryEntry &&
        other.id == id &&
        other.savedAt == savedAt &&
        other.result == result;
  }

  @override
  int get hashCode => Object.hash(id, savedAt, result);

  HistoryEntry copyWith({
    String? id,
    DateTime? savedAt,
    AnalysisResult? result,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      savedAt: savedAt ?? this.savedAt,
      result: result ?? this.result,
    );
  }
}