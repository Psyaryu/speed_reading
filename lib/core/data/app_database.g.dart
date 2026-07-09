// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _goalsJsonMeta =
      const VerificationMeta('goalsJson');
  @override
  late final GeneratedColumn<String> goalsJson = GeneratedColumn<String>(
      'goals_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _preferredFontSizeMeta =
      const VerificationMeta('preferredFontSize');
  @override
  late final GeneratedColumn<double> preferredFontSize =
      GeneratedColumn<double>('preferred_font_size', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _preferredLineHeightMeta =
      const VerificationMeta('preferredLineHeight');
  @override
  late final GeneratedColumn<double> preferredLineHeight =
      GeneratedColumn<double>('preferred_line_height', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _preferredColumnWidthMeta =
      const VerificationMeta('preferredColumnWidth');
  @override
  late final GeneratedColumn<double> preferredColumnWidth =
      GeneratedColumn<double>('preferred_column_width', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(760.0));
  static const VerificationMeta _preferredThemeModeMeta =
      const VerificationMeta('preferredThemeMode');
  @override
  late final GeneratedColumn<String> preferredThemeMode =
      GeneratedColumn<String>('preferred_theme_mode', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('system'));
  static const VerificationMeta _reducedMotionMeta =
      const VerificationMeta('reducedMotion');
  @override
  late final GeneratedColumn<bool> reducedMotion = GeneratedColumn<bool>(
      'reduced_motion', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reduced_motion" IN (0, 1))'));
  static const VerificationMeta _baselineWpmMeta =
      const VerificationMeta('baselineWpm');
  @override
  late final GeneratedColumn<double> baselineWpm = GeneratedColumn<double>(
      'baseline_wpm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _baselineComprehensionMeta =
      const VerificationMeta('baselineComprehension');
  @override
  late final GeneratedColumn<double> baselineComprehension =
      GeneratedColumn<double>('baseline_comprehension', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _baselineEffectiveReadingScoreMeta =
      const VerificationMeta('baselineEffectiveReadingScore');
  @override
  late final GeneratedColumn<double> baselineEffectiveReadingScore =
      GeneratedColumn<double>(
          'baseline_effective_reading_score', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        goalsJson,
        preferredFontSize,
        preferredLineHeight,
        preferredColumnWidth,
        preferredThemeMode,
        reducedMotion,
        baselineWpm,
        baselineComprehension,
        baselineEffectiveReadingScore
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('goals_json')) {
      context.handle(_goalsJsonMeta,
          goalsJson.isAcceptableOrUnknown(data['goals_json']!, _goalsJsonMeta));
    } else if (isInserting) {
      context.missing(_goalsJsonMeta);
    }
    if (data.containsKey('preferred_font_size')) {
      context.handle(
          _preferredFontSizeMeta,
          preferredFontSize.isAcceptableOrUnknown(
              data['preferred_font_size']!, _preferredFontSizeMeta));
    } else if (isInserting) {
      context.missing(_preferredFontSizeMeta);
    }
    if (data.containsKey('preferred_line_height')) {
      context.handle(
          _preferredLineHeightMeta,
          preferredLineHeight.isAcceptableOrUnknown(
              data['preferred_line_height']!, _preferredLineHeightMeta));
    } else if (isInserting) {
      context.missing(_preferredLineHeightMeta);
    }
    if (data.containsKey('preferred_column_width')) {
      context.handle(
          _preferredColumnWidthMeta,
          preferredColumnWidth.isAcceptableOrUnknown(
              data['preferred_column_width']!, _preferredColumnWidthMeta));
    }
    if (data.containsKey('preferred_theme_mode')) {
      context.handle(
          _preferredThemeModeMeta,
          preferredThemeMode.isAcceptableOrUnknown(
              data['preferred_theme_mode']!, _preferredThemeModeMeta));
    }
    if (data.containsKey('reduced_motion')) {
      context.handle(
          _reducedMotionMeta,
          reducedMotion.isAcceptableOrUnknown(
              data['reduced_motion']!, _reducedMotionMeta));
    } else if (isInserting) {
      context.missing(_reducedMotionMeta);
    }
    if (data.containsKey('baseline_wpm')) {
      context.handle(
          _baselineWpmMeta,
          baselineWpm.isAcceptableOrUnknown(
              data['baseline_wpm']!, _baselineWpmMeta));
    }
    if (data.containsKey('baseline_comprehension')) {
      context.handle(
          _baselineComprehensionMeta,
          baselineComprehension.isAcceptableOrUnknown(
              data['baseline_comprehension']!, _baselineComprehensionMeta));
    }
    if (data.containsKey('baseline_effective_reading_score')) {
      context.handle(
          _baselineEffectiveReadingScoreMeta,
          baselineEffectiveReadingScore.isAcceptableOrUnknown(
              data['baseline_effective_reading_score']!,
              _baselineEffectiveReadingScoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      goalsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goals_json'])!,
      preferredFontSize: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}preferred_font_size'])!,
      preferredLineHeight: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}preferred_line_height'])!,
      preferredColumnWidth: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}preferred_column_width'])!,
      preferredThemeMode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_theme_mode'])!,
      reducedMotion: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reduced_motion'])!,
      baselineWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}baseline_wpm']),
      baselineComprehension: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}baseline_comprehension']),
      baselineEffectiveReadingScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}baseline_effective_reading_score']),
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
  final String id;
  final DateTime createdAt;
  final String goalsJson;
  final double preferredFontSize;
  final double preferredLineHeight;
  final double preferredColumnWidth;
  final String preferredThemeMode;
  final bool reducedMotion;
  final double? baselineWpm;
  final double? baselineComprehension;
  final double? baselineEffectiveReadingScore;
  const LocalProfile(
      {required this.id,
      required this.createdAt,
      required this.goalsJson,
      required this.preferredFontSize,
      required this.preferredLineHeight,
      required this.preferredColumnWidth,
      required this.preferredThemeMode,
      required this.reducedMotion,
      this.baselineWpm,
      this.baselineComprehension,
      this.baselineEffectiveReadingScore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['goals_json'] = Variable<String>(goalsJson);
    map['preferred_font_size'] = Variable<double>(preferredFontSize);
    map['preferred_line_height'] = Variable<double>(preferredLineHeight);
    map['preferred_column_width'] = Variable<double>(preferredColumnWidth);
    map['preferred_theme_mode'] = Variable<String>(preferredThemeMode);
    map['reduced_motion'] = Variable<bool>(reducedMotion);
    if (!nullToAbsent || baselineWpm != null) {
      map['baseline_wpm'] = Variable<double>(baselineWpm);
    }
    if (!nullToAbsent || baselineComprehension != null) {
      map['baseline_comprehension'] = Variable<double>(baselineComprehension);
    }
    if (!nullToAbsent || baselineEffectiveReadingScore != null) {
      map['baseline_effective_reading_score'] =
          Variable<double>(baselineEffectiveReadingScore);
    }
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      goalsJson: Value(goalsJson),
      preferredFontSize: Value(preferredFontSize),
      preferredLineHeight: Value(preferredLineHeight),
      preferredColumnWidth: Value(preferredColumnWidth),
      preferredThemeMode: Value(preferredThemeMode),
      reducedMotion: Value(reducedMotion),
      baselineWpm: baselineWpm == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineWpm),
      baselineComprehension: baselineComprehension == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineComprehension),
      baselineEffectiveReadingScore:
          baselineEffectiveReadingScore == null && nullToAbsent
              ? const Value.absent()
              : Value(baselineEffectiveReadingScore),
    );
  }

  factory LocalProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      goalsJson: serializer.fromJson<String>(json['goalsJson']),
      preferredFontSize: serializer.fromJson<double>(json['preferredFontSize']),
      preferredLineHeight:
          serializer.fromJson<double>(json['preferredLineHeight']),
      preferredColumnWidth:
          serializer.fromJson<double>(json['preferredColumnWidth']),
      preferredThemeMode:
          serializer.fromJson<String>(json['preferredThemeMode']),
      reducedMotion: serializer.fromJson<bool>(json['reducedMotion']),
      baselineWpm: serializer.fromJson<double?>(json['baselineWpm']),
      baselineComprehension:
          serializer.fromJson<double?>(json['baselineComprehension']),
      baselineEffectiveReadingScore:
          serializer.fromJson<double?>(json['baselineEffectiveReadingScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'goalsJson': serializer.toJson<String>(goalsJson),
      'preferredFontSize': serializer.toJson<double>(preferredFontSize),
      'preferredLineHeight': serializer.toJson<double>(preferredLineHeight),
      'preferredColumnWidth': serializer.toJson<double>(preferredColumnWidth),
      'preferredThemeMode': serializer.toJson<String>(preferredThemeMode),
      'reducedMotion': serializer.toJson<bool>(reducedMotion),
      'baselineWpm': serializer.toJson<double?>(baselineWpm),
      'baselineComprehension':
          serializer.toJson<double?>(baselineComprehension),
      'baselineEffectiveReadingScore':
          serializer.toJson<double?>(baselineEffectiveReadingScore),
    };
  }

  LocalProfile copyWith(
          {String? id,
          DateTime? createdAt,
          String? goalsJson,
          double? preferredFontSize,
          double? preferredLineHeight,
          double? preferredColumnWidth,
          String? preferredThemeMode,
          bool? reducedMotion,
          Value<double?> baselineWpm = const Value.absent(),
          Value<double?> baselineComprehension = const Value.absent(),
          Value<double?> baselineEffectiveReadingScore =
              const Value.absent()}) =>
      LocalProfile(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        goalsJson: goalsJson ?? this.goalsJson,
        preferredFontSize: preferredFontSize ?? this.preferredFontSize,
        preferredLineHeight: preferredLineHeight ?? this.preferredLineHeight,
        preferredColumnWidth: preferredColumnWidth ?? this.preferredColumnWidth,
        preferredThemeMode: preferredThemeMode ?? this.preferredThemeMode,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        baselineWpm: baselineWpm.present ? baselineWpm.value : this.baselineWpm,
        baselineComprehension: baselineComprehension.present
            ? baselineComprehension.value
            : this.baselineComprehension,
        baselineEffectiveReadingScore: baselineEffectiveReadingScore.present
            ? baselineEffectiveReadingScore.value
            : this.baselineEffectiveReadingScore,
      );
  LocalProfile copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      goalsJson: data.goalsJson.present ? data.goalsJson.value : this.goalsJson,
      preferredFontSize: data.preferredFontSize.present
          ? data.preferredFontSize.value
          : this.preferredFontSize,
      preferredLineHeight: data.preferredLineHeight.present
          ? data.preferredLineHeight.value
          : this.preferredLineHeight,
      preferredColumnWidth: data.preferredColumnWidth.present
          ? data.preferredColumnWidth.value
          : this.preferredColumnWidth,
      preferredThemeMode: data.preferredThemeMode.present
          ? data.preferredThemeMode.value
          : this.preferredThemeMode,
      reducedMotion: data.reducedMotion.present
          ? data.reducedMotion.value
          : this.reducedMotion,
      baselineWpm:
          data.baselineWpm.present ? data.baselineWpm.value : this.baselineWpm,
      baselineComprehension: data.baselineComprehension.present
          ? data.baselineComprehension.value
          : this.baselineComprehension,
      baselineEffectiveReadingScore: data.baselineEffectiveReadingScore.present
          ? data.baselineEffectiveReadingScore.value
          : this.baselineEffectiveReadingScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('goalsJson: $goalsJson, ')
          ..write('preferredFontSize: $preferredFontSize, ')
          ..write('preferredLineHeight: $preferredLineHeight, ')
          ..write('preferredColumnWidth: $preferredColumnWidth, ')
          ..write('preferredThemeMode: $preferredThemeMode, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('baselineWpm: $baselineWpm, ')
          ..write('baselineComprehension: $baselineComprehension, ')
          ..write(
              'baselineEffectiveReadingScore: $baselineEffectiveReadingScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createdAt,
      goalsJson,
      preferredFontSize,
      preferredLineHeight,
      preferredColumnWidth,
      preferredThemeMode,
      reducedMotion,
      baselineWpm,
      baselineComprehension,
      baselineEffectiveReadingScore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.goalsJson == this.goalsJson &&
          other.preferredFontSize == this.preferredFontSize &&
          other.preferredLineHeight == this.preferredLineHeight &&
          other.preferredColumnWidth == this.preferredColumnWidth &&
          other.preferredThemeMode == this.preferredThemeMode &&
          other.reducedMotion == this.reducedMotion &&
          other.baselineWpm == this.baselineWpm &&
          other.baselineComprehension == this.baselineComprehension &&
          other.baselineEffectiveReadingScore ==
              this.baselineEffectiveReadingScore);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<String> goalsJson;
  final Value<double> preferredFontSize;
  final Value<double> preferredLineHeight;
  final Value<double> preferredColumnWidth;
  final Value<String> preferredThemeMode;
  final Value<bool> reducedMotion;
  final Value<double?> baselineWpm;
  final Value<double?> baselineComprehension;
  final Value<double?> baselineEffectiveReadingScore;
  final Value<int> rowid;
  const LocalProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.goalsJson = const Value.absent(),
    this.preferredFontSize = const Value.absent(),
    this.preferredLineHeight = const Value.absent(),
    this.preferredColumnWidth = const Value.absent(),
    this.preferredThemeMode = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.baselineWpm = const Value.absent(),
    this.baselineComprehension = const Value.absent(),
    this.baselineEffectiveReadingScore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required String goalsJson,
    required double preferredFontSize,
    required double preferredLineHeight,
    this.preferredColumnWidth = const Value.absent(),
    this.preferredThemeMode = const Value.absent(),
    required bool reducedMotion,
    this.baselineWpm = const Value.absent(),
    this.baselineComprehension = const Value.absent(),
    this.baselineEffectiveReadingScore = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        goalsJson = Value(goalsJson),
        preferredFontSize = Value(preferredFontSize),
        preferredLineHeight = Value(preferredLineHeight),
        reducedMotion = Value(reducedMotion);
  static Insertable<LocalProfile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? goalsJson,
    Expression<double>? preferredFontSize,
    Expression<double>? preferredLineHeight,
    Expression<double>? preferredColumnWidth,
    Expression<String>? preferredThemeMode,
    Expression<bool>? reducedMotion,
    Expression<double>? baselineWpm,
    Expression<double>? baselineComprehension,
    Expression<double>? baselineEffectiveReadingScore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (goalsJson != null) 'goals_json': goalsJson,
      if (preferredFontSize != null) 'preferred_font_size': preferredFontSize,
      if (preferredLineHeight != null)
        'preferred_line_height': preferredLineHeight,
      if (preferredColumnWidth != null)
        'preferred_column_width': preferredColumnWidth,
      if (preferredThemeMode != null)
        'preferred_theme_mode': preferredThemeMode,
      if (reducedMotion != null) 'reduced_motion': reducedMotion,
      if (baselineWpm != null) 'baseline_wpm': baselineWpm,
      if (baselineComprehension != null)
        'baseline_comprehension': baselineComprehension,
      if (baselineEffectiveReadingScore != null)
        'baseline_effective_reading_score': baselineEffectiveReadingScore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProfilesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<String>? goalsJson,
      Value<double>? preferredFontSize,
      Value<double>? preferredLineHeight,
      Value<double>? preferredColumnWidth,
      Value<String>? preferredThemeMode,
      Value<bool>? reducedMotion,
      Value<double?>? baselineWpm,
      Value<double?>? baselineComprehension,
      Value<double?>? baselineEffectiveReadingScore,
      Value<int>? rowid}) {
    return LocalProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      goalsJson: goalsJson ?? this.goalsJson,
      preferredFontSize: preferredFontSize ?? this.preferredFontSize,
      preferredLineHeight: preferredLineHeight ?? this.preferredLineHeight,
      preferredColumnWidth: preferredColumnWidth ?? this.preferredColumnWidth,
      preferredThemeMode: preferredThemeMode ?? this.preferredThemeMode,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      baselineWpm: baselineWpm ?? this.baselineWpm,
      baselineComprehension:
          baselineComprehension ?? this.baselineComprehension,
      baselineEffectiveReadingScore:
          baselineEffectiveReadingScore ?? this.baselineEffectiveReadingScore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (goalsJson.present) {
      map['goals_json'] = Variable<String>(goalsJson.value);
    }
    if (preferredFontSize.present) {
      map['preferred_font_size'] = Variable<double>(preferredFontSize.value);
    }
    if (preferredLineHeight.present) {
      map['preferred_line_height'] =
          Variable<double>(preferredLineHeight.value);
    }
    if (preferredColumnWidth.present) {
      map['preferred_column_width'] =
          Variable<double>(preferredColumnWidth.value);
    }
    if (preferredThemeMode.present) {
      map['preferred_theme_mode'] = Variable<String>(preferredThemeMode.value);
    }
    if (reducedMotion.present) {
      map['reduced_motion'] = Variable<bool>(reducedMotion.value);
    }
    if (baselineWpm.present) {
      map['baseline_wpm'] = Variable<double>(baselineWpm.value);
    }
    if (baselineComprehension.present) {
      map['baseline_comprehension'] =
          Variable<double>(baselineComprehension.value);
    }
    if (baselineEffectiveReadingScore.present) {
      map['baseline_effective_reading_score'] =
          Variable<double>(baselineEffectiveReadingScore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('goalsJson: $goalsJson, ')
          ..write('preferredFontSize: $preferredFontSize, ')
          ..write('preferredLineHeight: $preferredLineHeight, ')
          ..write('preferredColumnWidth: $preferredColumnWidth, ')
          ..write('preferredThemeMode: $preferredThemeMode, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('baselineWpm: $baselineWpm, ')
          ..write('baselineComprehension: $baselineComprehension, ')
          ..write(
              'baselineEffectiveReadingScore: $baselineEffectiveReadingScore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PassageRecordsTable extends PassageRecords
    with TableInfo<$PassageRecordsTable, PassageRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassageRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, body, source, metadataJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passage_records';
  @override
  VerificationContext validateIntegrity(Insertable<PassageRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    } else if (isInserting) {
      context.missing(_metadataJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PassageRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PassageRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json'])!,
    );
  }

  @override
  $PassageRecordsTable createAlias(String alias) {
    return $PassageRecordsTable(attachedDatabase, alias);
  }
}

class PassageRecord extends DataClass implements Insertable<PassageRecord> {
  final String id;
  final String title;
  final String body;
  final String source;
  final String metadataJson;
  const PassageRecord(
      {required this.id,
      required this.title,
      required this.body,
      required this.source,
      required this.metadataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['source'] = Variable<String>(source);
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  PassageRecordsCompanion toCompanion(bool nullToAbsent) {
    return PassageRecordsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      source: Value(source),
      metadataJson: Value(metadataJson),
    );
  }

  factory PassageRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PassageRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      source: serializer.fromJson<String>(json['source']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'source': serializer.toJson<String>(source),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  PassageRecord copyWith(
          {String? id,
          String? title,
          String? body,
          String? source,
          String? metadataJson}) =>
      PassageRecord(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        source: source ?? this.source,
        metadataJson: metadataJson ?? this.metadataJson,
      );
  PassageRecord copyWithCompanion(PassageRecordsCompanion data) {
    return PassageRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      source: data.source.present ? data.source.value : this.source,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PassageRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('source: $source, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, source, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PassageRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.source == this.source &&
          other.metadataJson == this.metadataJson);
}

class PassageRecordsCompanion extends UpdateCompanion<PassageRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> source;
  final Value<String> metadataJson;
  final Value<int> rowid;
  const PassageRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.source = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PassageRecordsCompanion.insert({
    required String id,
    required String title,
    required String body,
    required String source,
    required String metadataJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        source = Value(source),
        metadataJson = Value(metadataJson);
  static Insertable<PassageRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? source,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (source != null) 'source': source,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PassageRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String>? source,
      Value<String>? metadataJson,
      Value<int>? rowid}) {
    return PassageRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      source: source ?? this.source,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassageRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('source: $source, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionRecordsTable extends ReadingSessionRecords
    with TableInfo<$ReadingSessionRecordsTable, ReadingSessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passageIdMeta =
      const VerificationMeta('passageId');
  @override
  late final GeneratedColumn<String> passageId = GeneratedColumn<String>(
      'passage_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _activeReadingSecondsMeta =
      const VerificationMeta('activeReadingSeconds');
  @override
  late final GeneratedColumn<int> activeReadingSeconds = GeneratedColumn<int>(
      'active_reading_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wordCountMeta =
      const VerificationMeta('wordCount');
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
      'word_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetWpmMeta =
      const VerificationMeta('targetWpm');
  @override
  late final GeneratedColumn<int> targetWpm = GeneratedColumn<int>(
      'target_wpm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pauseCountMeta =
      const VerificationMeta('pauseCount');
  @override
  late final GeneratedColumn<int> pauseCount = GeneratedColumn<int>(
      'pause_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userConfidenceRatingMeta =
      const VerificationMeta('userConfidenceRating');
  @override
  late final GeneratedColumn<int> userConfidenceRating = GeneratedColumn<int>(
      'user_confidence_rating', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _selfRatedFocusMeta =
      const VerificationMeta('selfRatedFocus');
  @override
  late final GeneratedColumn<int> selfRatedFocus = GeneratedColumn<int>(
      'self_rated_focus', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        passageId,
        mode,
        startedAt,
        completedAt,
        activeReadingSeconds,
        wordCount,
        status,
        targetWpm,
        pauseCount,
        userConfidenceRating,
        selfRatedFocus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_session_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReadingSessionRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('passage_id')) {
      context.handle(_passageIdMeta,
          passageId.isAcceptableOrUnknown(data['passage_id']!, _passageIdMeta));
    } else if (isInserting) {
      context.missing(_passageIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('active_reading_seconds')) {
      context.handle(
          _activeReadingSecondsMeta,
          activeReadingSeconds.isAcceptableOrUnknown(
              data['active_reading_seconds']!, _activeReadingSecondsMeta));
    } else if (isInserting) {
      context.missing(_activeReadingSecondsMeta);
    }
    if (data.containsKey('word_count')) {
      context.handle(_wordCountMeta,
          wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta));
    } else if (isInserting) {
      context.missing(_wordCountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('target_wpm')) {
      context.handle(_targetWpmMeta,
          targetWpm.isAcceptableOrUnknown(data['target_wpm']!, _targetWpmMeta));
    }
    if (data.containsKey('pause_count')) {
      context.handle(
          _pauseCountMeta,
          pauseCount.isAcceptableOrUnknown(
              data['pause_count']!, _pauseCountMeta));
    } else if (isInserting) {
      context.missing(_pauseCountMeta);
    }
    if (data.containsKey('user_confidence_rating')) {
      context.handle(
          _userConfidenceRatingMeta,
          userConfidenceRating.isAcceptableOrUnknown(
              data['user_confidence_rating']!, _userConfidenceRatingMeta));
    }
    if (data.containsKey('self_rated_focus')) {
      context.handle(
          _selfRatedFocusMeta,
          selfRatedFocus.isAcceptableOrUnknown(
              data['self_rated_focus']!, _selfRatedFocusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSessionRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      passageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}passage_id'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      activeReadingSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}active_reading_seconds'])!,
      wordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      targetWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_wpm']),
      pauseCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pause_count'])!,
      userConfidenceRating: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}user_confidence_rating']),
      selfRatedFocus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}self_rated_focus']),
    );
  }

  @override
  $ReadingSessionRecordsTable createAlias(String alias) {
    return $ReadingSessionRecordsTable(attachedDatabase, alias);
  }
}

class ReadingSessionRecord extends DataClass
    implements Insertable<ReadingSessionRecord> {
  final String id;
  final String passageId;
  final String mode;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int activeReadingSeconds;
  final int wordCount;
  final String status;
  final int? targetWpm;
  final int pauseCount;
  final int? userConfidenceRating;
  final int? selfRatedFocus;
  const ReadingSessionRecord(
      {required this.id,
      required this.passageId,
      required this.mode,
      required this.startedAt,
      this.completedAt,
      required this.activeReadingSeconds,
      required this.wordCount,
      required this.status,
      this.targetWpm,
      required this.pauseCount,
      this.userConfidenceRating,
      this.selfRatedFocus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['passage_id'] = Variable<String>(passageId);
    map['mode'] = Variable<String>(mode);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['active_reading_seconds'] = Variable<int>(activeReadingSeconds);
    map['word_count'] = Variable<int>(wordCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || targetWpm != null) {
      map['target_wpm'] = Variable<int>(targetWpm);
    }
    map['pause_count'] = Variable<int>(pauseCount);
    if (!nullToAbsent || userConfidenceRating != null) {
      map['user_confidence_rating'] = Variable<int>(userConfidenceRating);
    }
    if (!nullToAbsent || selfRatedFocus != null) {
      map['self_rated_focus'] = Variable<int>(selfRatedFocus);
    }
    return map;
  }

  ReadingSessionRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionRecordsCompanion(
      id: Value(id),
      passageId: Value(passageId),
      mode: Value(mode),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      activeReadingSeconds: Value(activeReadingSeconds),
      wordCount: Value(wordCount),
      status: Value(status),
      targetWpm: targetWpm == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWpm),
      pauseCount: Value(pauseCount),
      userConfidenceRating: userConfidenceRating == null && nullToAbsent
          ? const Value.absent()
          : Value(userConfidenceRating),
      selfRatedFocus: selfRatedFocus == null && nullToAbsent
          ? const Value.absent()
          : Value(selfRatedFocus),
    );
  }

  factory ReadingSessionRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSessionRecord(
      id: serializer.fromJson<String>(json['id']),
      passageId: serializer.fromJson<String>(json['passageId']),
      mode: serializer.fromJson<String>(json['mode']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      activeReadingSeconds:
          serializer.fromJson<int>(json['activeReadingSeconds']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      status: serializer.fromJson<String>(json['status']),
      targetWpm: serializer.fromJson<int?>(json['targetWpm']),
      pauseCount: serializer.fromJson<int>(json['pauseCount']),
      userConfidenceRating:
          serializer.fromJson<int?>(json['userConfidenceRating']),
      selfRatedFocus: serializer.fromJson<int?>(json['selfRatedFocus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'passageId': serializer.toJson<String>(passageId),
      'mode': serializer.toJson<String>(mode),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'activeReadingSeconds': serializer.toJson<int>(activeReadingSeconds),
      'wordCount': serializer.toJson<int>(wordCount),
      'status': serializer.toJson<String>(status),
      'targetWpm': serializer.toJson<int?>(targetWpm),
      'pauseCount': serializer.toJson<int>(pauseCount),
      'userConfidenceRating': serializer.toJson<int?>(userConfidenceRating),
      'selfRatedFocus': serializer.toJson<int?>(selfRatedFocus),
    };
  }

  ReadingSessionRecord copyWith(
          {String? id,
          String? passageId,
          String? mode,
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          int? activeReadingSeconds,
          int? wordCount,
          String? status,
          Value<int?> targetWpm = const Value.absent(),
          int? pauseCount,
          Value<int?> userConfidenceRating = const Value.absent(),
          Value<int?> selfRatedFocus = const Value.absent()}) =>
      ReadingSessionRecord(
        id: id ?? this.id,
        passageId: passageId ?? this.passageId,
        mode: mode ?? this.mode,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        activeReadingSeconds: activeReadingSeconds ?? this.activeReadingSeconds,
        wordCount: wordCount ?? this.wordCount,
        status: status ?? this.status,
        targetWpm: targetWpm.present ? targetWpm.value : this.targetWpm,
        pauseCount: pauseCount ?? this.pauseCount,
        userConfidenceRating: userConfidenceRating.present
            ? userConfidenceRating.value
            : this.userConfidenceRating,
        selfRatedFocus:
            selfRatedFocus.present ? selfRatedFocus.value : this.selfRatedFocus,
      );
  ReadingSessionRecord copyWithCompanion(ReadingSessionRecordsCompanion data) {
    return ReadingSessionRecord(
      id: data.id.present ? data.id.value : this.id,
      passageId: data.passageId.present ? data.passageId.value : this.passageId,
      mode: data.mode.present ? data.mode.value : this.mode,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      activeReadingSeconds: data.activeReadingSeconds.present
          ? data.activeReadingSeconds.value
          : this.activeReadingSeconds,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      status: data.status.present ? data.status.value : this.status,
      targetWpm: data.targetWpm.present ? data.targetWpm.value : this.targetWpm,
      pauseCount:
          data.pauseCount.present ? data.pauseCount.value : this.pauseCount,
      userConfidenceRating: data.userConfidenceRating.present
          ? data.userConfidenceRating.value
          : this.userConfidenceRating,
      selfRatedFocus: data.selfRatedFocus.present
          ? data.selfRatedFocus.value
          : this.selfRatedFocus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionRecord(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('mode: $mode, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('activeReadingSeconds: $activeReadingSeconds, ')
          ..write('wordCount: $wordCount, ')
          ..write('status: $status, ')
          ..write('targetWpm: $targetWpm, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('userConfidenceRating: $userConfidenceRating, ')
          ..write('selfRatedFocus: $selfRatedFocus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      passageId,
      mode,
      startedAt,
      completedAt,
      activeReadingSeconds,
      wordCount,
      status,
      targetWpm,
      pauseCount,
      userConfidenceRating,
      selfRatedFocus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSessionRecord &&
          other.id == this.id &&
          other.passageId == this.passageId &&
          other.mode == this.mode &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.activeReadingSeconds == this.activeReadingSeconds &&
          other.wordCount == this.wordCount &&
          other.status == this.status &&
          other.targetWpm == this.targetWpm &&
          other.pauseCount == this.pauseCount &&
          other.userConfidenceRating == this.userConfidenceRating &&
          other.selfRatedFocus == this.selfRatedFocus);
}

class ReadingSessionRecordsCompanion
    extends UpdateCompanion<ReadingSessionRecord> {
  final Value<String> id;
  final Value<String> passageId;
  final Value<String> mode;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> activeReadingSeconds;
  final Value<int> wordCount;
  final Value<String> status;
  final Value<int?> targetWpm;
  final Value<int> pauseCount;
  final Value<int?> userConfidenceRating;
  final Value<int?> selfRatedFocus;
  final Value<int> rowid;
  const ReadingSessionRecordsCompanion({
    this.id = const Value.absent(),
    this.passageId = const Value.absent(),
    this.mode = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.activeReadingSeconds = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.status = const Value.absent(),
    this.targetWpm = const Value.absent(),
    this.pauseCount = const Value.absent(),
    this.userConfidenceRating = const Value.absent(),
    this.selfRatedFocus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingSessionRecordsCompanion.insert({
    required String id,
    required String passageId,
    required String mode,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required int activeReadingSeconds,
    required int wordCount,
    required String status,
    this.targetWpm = const Value.absent(),
    required int pauseCount,
    this.userConfidenceRating = const Value.absent(),
    this.selfRatedFocus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        passageId = Value(passageId),
        mode = Value(mode),
        startedAt = Value(startedAt),
        activeReadingSeconds = Value(activeReadingSeconds),
        wordCount = Value(wordCount),
        status = Value(status),
        pauseCount = Value(pauseCount);
  static Insertable<ReadingSessionRecord> custom({
    Expression<String>? id,
    Expression<String>? passageId,
    Expression<String>? mode,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? activeReadingSeconds,
    Expression<int>? wordCount,
    Expression<String>? status,
    Expression<int>? targetWpm,
    Expression<int>? pauseCount,
    Expression<int>? userConfidenceRating,
    Expression<int>? selfRatedFocus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (passageId != null) 'passage_id': passageId,
      if (mode != null) 'mode': mode,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (activeReadingSeconds != null)
        'active_reading_seconds': activeReadingSeconds,
      if (wordCount != null) 'word_count': wordCount,
      if (status != null) 'status': status,
      if (targetWpm != null) 'target_wpm': targetWpm,
      if (pauseCount != null) 'pause_count': pauseCount,
      if (userConfidenceRating != null)
        'user_confidence_rating': userConfidenceRating,
      if (selfRatedFocus != null) 'self_rated_focus': selfRatedFocus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingSessionRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? passageId,
      Value<String>? mode,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<int>? activeReadingSeconds,
      Value<int>? wordCount,
      Value<String>? status,
      Value<int?>? targetWpm,
      Value<int>? pauseCount,
      Value<int?>? userConfidenceRating,
      Value<int?>? selfRatedFocus,
      Value<int>? rowid}) {
    return ReadingSessionRecordsCompanion(
      id: id ?? this.id,
      passageId: passageId ?? this.passageId,
      mode: mode ?? this.mode,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      activeReadingSeconds: activeReadingSeconds ?? this.activeReadingSeconds,
      wordCount: wordCount ?? this.wordCount,
      status: status ?? this.status,
      targetWpm: targetWpm ?? this.targetWpm,
      pauseCount: pauseCount ?? this.pauseCount,
      userConfidenceRating: userConfidenceRating ?? this.userConfidenceRating,
      selfRatedFocus: selfRatedFocus ?? this.selfRatedFocus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (passageId.present) {
      map['passage_id'] = Variable<String>(passageId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (activeReadingSeconds.present) {
      map['active_reading_seconds'] = Variable<int>(activeReadingSeconds.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (targetWpm.present) {
      map['target_wpm'] = Variable<int>(targetWpm.value);
    }
    if (pauseCount.present) {
      map['pause_count'] = Variable<int>(pauseCount.value);
    }
    if (userConfidenceRating.present) {
      map['user_confidence_rating'] = Variable<int>(userConfidenceRating.value);
    }
    if (selfRatedFocus.present) {
      map['self_rated_focus'] = Variable<int>(selfRatedFocus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('mode: $mode, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('activeReadingSeconds: $activeReadingSeconds, ')
          ..write('wordCount: $wordCount, ')
          ..write('status: $status, ')
          ..write('targetWpm: $targetWpm, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('userConfidenceRating: $userConfidenceRating, ')
          ..write('selfRatedFocus: $selfRatedFocus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizResultRecordsTable extends QuizResultRecords
    with TableInfo<$QuizResultRecordsTable, QuizResultRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizResultRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passageIdMeta =
      const VerificationMeta('passageId');
  @override
  late final GeneratedColumn<String> passageId = GeneratedColumn<String>(
      'passage_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalQuestionsMeta =
      const VerificationMeta('totalQuestions');
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
      'total_questions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _answersByQuestionIdJsonMeta =
      const VerificationMeta('answersByQuestionIdJson');
  @override
  late final GeneratedColumn<String> answersByQuestionIdJson =
      GeneratedColumn<String>('answers_by_question_id_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionTypesByQuestionIdJsonMeta =
      const VerificationMeta('questionTypesByQuestionIdJson');
  @override
  late final GeneratedColumn<String> questionTypesByQuestionIdJson =
      GeneratedColumn<String>(
          'question_types_by_question_id_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('{}'));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _writtenSummaryMeta =
      const VerificationMeta('writtenSummary');
  @override
  late final GeneratedColumn<String> writtenSummary = GeneratedColumn<String>(
      'written_summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        passageId,
        correctCount,
        totalQuestions,
        answersByQuestionIdJson,
        questionTypesByQuestionIdJson,
        completedAt,
        writtenSummary
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_result_records';
  @override
  VerificationContext validateIntegrity(Insertable<QuizResultRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('passage_id')) {
      context.handle(_passageIdMeta,
          passageId.isAcceptableOrUnknown(data['passage_id']!, _passageIdMeta));
    } else if (isInserting) {
      context.missing(_passageIdMeta);
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    } else if (isInserting) {
      context.missing(_correctCountMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
          _totalQuestionsMeta,
          totalQuestions.isAcceptableOrUnknown(
              data['total_questions']!, _totalQuestionsMeta));
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('answers_by_question_id_json')) {
      context.handle(
          _answersByQuestionIdJsonMeta,
          answersByQuestionIdJson.isAcceptableOrUnknown(
              data['answers_by_question_id_json']!,
              _answersByQuestionIdJsonMeta));
    } else if (isInserting) {
      context.missing(_answersByQuestionIdJsonMeta);
    }
    if (data.containsKey('question_types_by_question_id_json')) {
      context.handle(
          _questionTypesByQuestionIdJsonMeta,
          questionTypesByQuestionIdJson.isAcceptableOrUnknown(
              data['question_types_by_question_id_json']!,
              _questionTypesByQuestionIdJsonMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('written_summary')) {
      context.handle(
          _writtenSummaryMeta,
          writtenSummary.isAcceptableOrUnknown(
              data['written_summary']!, _writtenSummaryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizResultRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizResultRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      passageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}passage_id'])!,
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
      totalQuestions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_questions'])!,
      answersByQuestionIdJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}answers_by_question_id_json'])!,
      questionTypesByQuestionIdJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}question_types_by_question_id_json'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
      writtenSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}written_summary']),
    );
  }

  @override
  $QuizResultRecordsTable createAlias(String alias) {
    return $QuizResultRecordsTable(attachedDatabase, alias);
  }
}

class QuizResultRecord extends DataClass
    implements Insertable<QuizResultRecord> {
  final String id;
  final String sessionId;
  final String passageId;
  final int correctCount;
  final int totalQuestions;
  final String answersByQuestionIdJson;
  final String questionTypesByQuestionIdJson;
  final DateTime completedAt;
  final String? writtenSummary;
  const QuizResultRecord(
      {required this.id,
      required this.sessionId,
      required this.passageId,
      required this.correctCount,
      required this.totalQuestions,
      required this.answersByQuestionIdJson,
      required this.questionTypesByQuestionIdJson,
      required this.completedAt,
      this.writtenSummary});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['passage_id'] = Variable<String>(passageId);
    map['correct_count'] = Variable<int>(correctCount);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['answers_by_question_id_json'] =
        Variable<String>(answersByQuestionIdJson);
    map['question_types_by_question_id_json'] =
        Variable<String>(questionTypesByQuestionIdJson);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || writtenSummary != null) {
      map['written_summary'] = Variable<String>(writtenSummary);
    }
    return map;
  }

  QuizResultRecordsCompanion toCompanion(bool nullToAbsent) {
    return QuizResultRecordsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      passageId: Value(passageId),
      correctCount: Value(correctCount),
      totalQuestions: Value(totalQuestions),
      answersByQuestionIdJson: Value(answersByQuestionIdJson),
      questionTypesByQuestionIdJson: Value(questionTypesByQuestionIdJson),
      completedAt: Value(completedAt),
      writtenSummary: writtenSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(writtenSummary),
    );
  }

  factory QuizResultRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizResultRecord(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      passageId: serializer.fromJson<String>(json['passageId']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      answersByQuestionIdJson:
          serializer.fromJson<String>(json['answersByQuestionIdJson']),
      questionTypesByQuestionIdJson:
          serializer.fromJson<String>(json['questionTypesByQuestionIdJson']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      writtenSummary: serializer.fromJson<String?>(json['writtenSummary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'passageId': serializer.toJson<String>(passageId),
      'correctCount': serializer.toJson<int>(correctCount),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'answersByQuestionIdJson':
          serializer.toJson<String>(answersByQuestionIdJson),
      'questionTypesByQuestionIdJson':
          serializer.toJson<String>(questionTypesByQuestionIdJson),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'writtenSummary': serializer.toJson<String?>(writtenSummary),
    };
  }

  QuizResultRecord copyWith(
          {String? id,
          String? sessionId,
          String? passageId,
          int? correctCount,
          int? totalQuestions,
          String? answersByQuestionIdJson,
          String? questionTypesByQuestionIdJson,
          DateTime? completedAt,
          Value<String?> writtenSummary = const Value.absent()}) =>
      QuizResultRecord(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        passageId: passageId ?? this.passageId,
        correctCount: correctCount ?? this.correctCount,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        answersByQuestionIdJson:
            answersByQuestionIdJson ?? this.answersByQuestionIdJson,
        questionTypesByQuestionIdJson:
            questionTypesByQuestionIdJson ?? this.questionTypesByQuestionIdJson,
        completedAt: completedAt ?? this.completedAt,
        writtenSummary:
            writtenSummary.present ? writtenSummary.value : this.writtenSummary,
      );
  QuizResultRecord copyWithCompanion(QuizResultRecordsCompanion data) {
    return QuizResultRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      passageId: data.passageId.present ? data.passageId.value : this.passageId,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      answersByQuestionIdJson: data.answersByQuestionIdJson.present
          ? data.answersByQuestionIdJson.value
          : this.answersByQuestionIdJson,
      questionTypesByQuestionIdJson: data.questionTypesByQuestionIdJson.present
          ? data.questionTypesByQuestionIdJson.value
          : this.questionTypesByQuestionIdJson,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      writtenSummary: data.writtenSummary.present
          ? data.writtenSummary.value
          : this.writtenSummary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizResultRecord(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('passageId: $passageId, ')
          ..write('correctCount: $correctCount, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('answersByQuestionIdJson: $answersByQuestionIdJson, ')
          ..write(
              'questionTypesByQuestionIdJson: $questionTypesByQuestionIdJson, ')
          ..write('completedAt: $completedAt, ')
          ..write('writtenSummary: $writtenSummary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      passageId,
      correctCount,
      totalQuestions,
      answersByQuestionIdJson,
      questionTypesByQuestionIdJson,
      completedAt,
      writtenSummary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizResultRecord &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.passageId == this.passageId &&
          other.correctCount == this.correctCount &&
          other.totalQuestions == this.totalQuestions &&
          other.answersByQuestionIdJson == this.answersByQuestionIdJson &&
          other.questionTypesByQuestionIdJson ==
              this.questionTypesByQuestionIdJson &&
          other.completedAt == this.completedAt &&
          other.writtenSummary == this.writtenSummary);
}

class QuizResultRecordsCompanion extends UpdateCompanion<QuizResultRecord> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> passageId;
  final Value<int> correctCount;
  final Value<int> totalQuestions;
  final Value<String> answersByQuestionIdJson;
  final Value<String> questionTypesByQuestionIdJson;
  final Value<DateTime> completedAt;
  final Value<String?> writtenSummary;
  final Value<int> rowid;
  const QuizResultRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.passageId = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.answersByQuestionIdJson = const Value.absent(),
    this.questionTypesByQuestionIdJson = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.writtenSummary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizResultRecordsCompanion.insert({
    required String id,
    required String sessionId,
    required String passageId,
    required int correctCount,
    required int totalQuestions,
    required String answersByQuestionIdJson,
    this.questionTypesByQuestionIdJson = const Value.absent(),
    required DateTime completedAt,
    this.writtenSummary = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        passageId = Value(passageId),
        correctCount = Value(correctCount),
        totalQuestions = Value(totalQuestions),
        answersByQuestionIdJson = Value(answersByQuestionIdJson),
        completedAt = Value(completedAt);
  static Insertable<QuizResultRecord> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? passageId,
    Expression<int>? correctCount,
    Expression<int>? totalQuestions,
    Expression<String>? answersByQuestionIdJson,
    Expression<String>? questionTypesByQuestionIdJson,
    Expression<DateTime>? completedAt,
    Expression<String>? writtenSummary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (passageId != null) 'passage_id': passageId,
      if (correctCount != null) 'correct_count': correctCount,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (answersByQuestionIdJson != null)
        'answers_by_question_id_json': answersByQuestionIdJson,
      if (questionTypesByQuestionIdJson != null)
        'question_types_by_question_id_json': questionTypesByQuestionIdJson,
      if (completedAt != null) 'completed_at': completedAt,
      if (writtenSummary != null) 'written_summary': writtenSummary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizResultRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String>? passageId,
      Value<int>? correctCount,
      Value<int>? totalQuestions,
      Value<String>? answersByQuestionIdJson,
      Value<String>? questionTypesByQuestionIdJson,
      Value<DateTime>? completedAt,
      Value<String?>? writtenSummary,
      Value<int>? rowid}) {
    return QuizResultRecordsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      passageId: passageId ?? this.passageId,
      correctCount: correctCount ?? this.correctCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      answersByQuestionIdJson:
          answersByQuestionIdJson ?? this.answersByQuestionIdJson,
      questionTypesByQuestionIdJson:
          questionTypesByQuestionIdJson ?? this.questionTypesByQuestionIdJson,
      completedAt: completedAt ?? this.completedAt,
      writtenSummary: writtenSummary ?? this.writtenSummary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (passageId.present) {
      map['passage_id'] = Variable<String>(passageId.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (answersByQuestionIdJson.present) {
      map['answers_by_question_id_json'] =
          Variable<String>(answersByQuestionIdJson.value);
    }
    if (questionTypesByQuestionIdJson.present) {
      map['question_types_by_question_id_json'] =
          Variable<String>(questionTypesByQuestionIdJson.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (writtenSummary.present) {
      map['written_summary'] = Variable<String>(writtenSummary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizResultRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('passageId: $passageId, ')
          ..write('correctCount: $correctCount, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('answersByQuestionIdJson: $answersByQuestionIdJson, ')
          ..write(
              'questionTypesByQuestionIdJson: $questionTypesByQuestionIdJson, ')
          ..write('completedAt: $completedAt, ')
          ..write('writtenSummary: $writtenSummary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DelayedRecallAttemptRecordsTable extends DelayedRecallAttemptRecords
    with
        TableInfo<$DelayedRecallAttemptRecordsTable,
            DelayedRecallAttemptRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DelayedRecallAttemptRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passageIdMeta =
      const VerificationMeta('passageId');
  @override
  late final GeneratedColumn<String> passageId = GeneratedColumn<String>(
      'passage_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _immediateSessionIdMeta =
      const VerificationMeta('immediateSessionId');
  @override
  late final GeneratedColumn<String> immediateSessionId =
      GeneratedColumn<String>('immediate_session_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _immediateQuizResultIdMeta =
      const VerificationMeta('immediateQuizResultId');
  @override
  late final GeneratedColumn<String> immediateQuizResultId =
      GeneratedColumn<String>('immediate_quiz_result_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recallCompletedAtMeta =
      const VerificationMeta('recallCompletedAt');
  @override
  late final GeneratedColumn<DateTime> recallCompletedAt =
      GeneratedColumn<DateTime>('recall_completed_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _immediateAttemptCompletedAtMeta =
      const VerificationMeta('immediateAttemptCompletedAt');
  @override
  late final GeneratedColumn<DateTime> immediateAttemptCompletedAt =
      GeneratedColumn<DateTime>(
          'immediate_attempt_completed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
      'score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        passageId,
        immediateSessionId,
        immediateQuizResultId,
        recallCompletedAt,
        immediateAttemptCompletedAt,
        dueAt,
        score
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'delayed_recall_attempt_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<DelayedRecallAttemptRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('passage_id')) {
      context.handle(_passageIdMeta,
          passageId.isAcceptableOrUnknown(data['passage_id']!, _passageIdMeta));
    } else if (isInserting) {
      context.missing(_passageIdMeta);
    }
    if (data.containsKey('immediate_session_id')) {
      context.handle(
          _immediateSessionIdMeta,
          immediateSessionId.isAcceptableOrUnknown(
              data['immediate_session_id']!, _immediateSessionIdMeta));
    }
    if (data.containsKey('immediate_quiz_result_id')) {
      context.handle(
          _immediateQuizResultIdMeta,
          immediateQuizResultId.isAcceptableOrUnknown(
              data['immediate_quiz_result_id']!, _immediateQuizResultIdMeta));
    }
    if (data.containsKey('recall_completed_at')) {
      context.handle(
          _recallCompletedAtMeta,
          recallCompletedAt.isAcceptableOrUnknown(
              data['recall_completed_at']!, _recallCompletedAtMeta));
    } else if (isInserting) {
      context.missing(_recallCompletedAtMeta);
    }
    if (data.containsKey('immediate_attempt_completed_at')) {
      context.handle(
          _immediateAttemptCompletedAtMeta,
          immediateAttemptCompletedAt.isAcceptableOrUnknown(
              data['immediate_attempt_completed_at']!,
              _immediateAttemptCompletedAtMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DelayedRecallAttemptRecord map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DelayedRecallAttemptRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      passageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}passage_id'])!,
      immediateSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}immediate_session_id']),
      immediateQuizResultId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}immediate_quiz_result_id']),
      recallCompletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}recall_completed_at'])!,
      immediateAttemptCompletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}immediate_attempt_completed_at']),
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at']),
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}score'])!,
    );
  }

  @override
  $DelayedRecallAttemptRecordsTable createAlias(String alias) {
    return $DelayedRecallAttemptRecordsTable(attachedDatabase, alias);
  }
}

class DelayedRecallAttemptRecord extends DataClass
    implements Insertable<DelayedRecallAttemptRecord> {
  final String id;
  final String passageId;
  final String? immediateSessionId;
  final String? immediateQuizResultId;
  final DateTime recallCompletedAt;
  final DateTime? immediateAttemptCompletedAt;
  final DateTime? dueAt;
  final double score;
  const DelayedRecallAttemptRecord(
      {required this.id,
      required this.passageId,
      this.immediateSessionId,
      this.immediateQuizResultId,
      required this.recallCompletedAt,
      this.immediateAttemptCompletedAt,
      this.dueAt,
      required this.score});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['passage_id'] = Variable<String>(passageId);
    if (!nullToAbsent || immediateSessionId != null) {
      map['immediate_session_id'] = Variable<String>(immediateSessionId);
    }
    if (!nullToAbsent || immediateQuizResultId != null) {
      map['immediate_quiz_result_id'] = Variable<String>(immediateQuizResultId);
    }
    map['recall_completed_at'] = Variable<DateTime>(recallCompletedAt);
    if (!nullToAbsent || immediateAttemptCompletedAt != null) {
      map['immediate_attempt_completed_at'] =
          Variable<DateTime>(immediateAttemptCompletedAt);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['score'] = Variable<double>(score);
    return map;
  }

  DelayedRecallAttemptRecordsCompanion toCompanion(bool nullToAbsent) {
    return DelayedRecallAttemptRecordsCompanion(
      id: Value(id),
      passageId: Value(passageId),
      immediateSessionId: immediateSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(immediateSessionId),
      immediateQuizResultId: immediateQuizResultId == null && nullToAbsent
          ? const Value.absent()
          : Value(immediateQuizResultId),
      recallCompletedAt: Value(recallCompletedAt),
      immediateAttemptCompletedAt:
          immediateAttemptCompletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(immediateAttemptCompletedAt),
      dueAt:
          dueAt == null && nullToAbsent ? const Value.absent() : Value(dueAt),
      score: Value(score),
    );
  }

  factory DelayedRecallAttemptRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DelayedRecallAttemptRecord(
      id: serializer.fromJson<String>(json['id']),
      passageId: serializer.fromJson<String>(json['passageId']),
      immediateSessionId:
          serializer.fromJson<String?>(json['immediateSessionId']),
      immediateQuizResultId:
          serializer.fromJson<String?>(json['immediateQuizResultId']),
      recallCompletedAt:
          serializer.fromJson<DateTime>(json['recallCompletedAt']),
      immediateAttemptCompletedAt:
          serializer.fromJson<DateTime?>(json['immediateAttemptCompletedAt']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      score: serializer.fromJson<double>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'passageId': serializer.toJson<String>(passageId),
      'immediateSessionId': serializer.toJson<String?>(immediateSessionId),
      'immediateQuizResultId':
          serializer.toJson<String?>(immediateQuizResultId),
      'recallCompletedAt': serializer.toJson<DateTime>(recallCompletedAt),
      'immediateAttemptCompletedAt':
          serializer.toJson<DateTime?>(immediateAttemptCompletedAt),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'score': serializer.toJson<double>(score),
    };
  }

  DelayedRecallAttemptRecord copyWith(
          {String? id,
          String? passageId,
          Value<String?> immediateSessionId = const Value.absent(),
          Value<String?> immediateQuizResultId = const Value.absent(),
          DateTime? recallCompletedAt,
          Value<DateTime?> immediateAttemptCompletedAt = const Value.absent(),
          Value<DateTime?> dueAt = const Value.absent(),
          double? score}) =>
      DelayedRecallAttemptRecord(
        id: id ?? this.id,
        passageId: passageId ?? this.passageId,
        immediateSessionId: immediateSessionId.present
            ? immediateSessionId.value
            : this.immediateSessionId,
        immediateQuizResultId: immediateQuizResultId.present
            ? immediateQuizResultId.value
            : this.immediateQuizResultId,
        recallCompletedAt: recallCompletedAt ?? this.recallCompletedAt,
        immediateAttemptCompletedAt: immediateAttemptCompletedAt.present
            ? immediateAttemptCompletedAt.value
            : this.immediateAttemptCompletedAt,
        dueAt: dueAt.present ? dueAt.value : this.dueAt,
        score: score ?? this.score,
      );
  DelayedRecallAttemptRecord copyWithCompanion(
      DelayedRecallAttemptRecordsCompanion data) {
    return DelayedRecallAttemptRecord(
      id: data.id.present ? data.id.value : this.id,
      passageId: data.passageId.present ? data.passageId.value : this.passageId,
      immediateSessionId: data.immediateSessionId.present
          ? data.immediateSessionId.value
          : this.immediateSessionId,
      immediateQuizResultId: data.immediateQuizResultId.present
          ? data.immediateQuizResultId.value
          : this.immediateQuizResultId,
      recallCompletedAt: data.recallCompletedAt.present
          ? data.recallCompletedAt.value
          : this.recallCompletedAt,
      immediateAttemptCompletedAt: data.immediateAttemptCompletedAt.present
          ? data.immediateAttemptCompletedAt.value
          : this.immediateAttemptCompletedAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DelayedRecallAttemptRecord(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('immediateSessionId: $immediateSessionId, ')
          ..write('immediateQuizResultId: $immediateQuizResultId, ')
          ..write('recallCompletedAt: $recallCompletedAt, ')
          ..write('immediateAttemptCompletedAt: $immediateAttemptCompletedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      passageId,
      immediateSessionId,
      immediateQuizResultId,
      recallCompletedAt,
      immediateAttemptCompletedAt,
      dueAt,
      score);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DelayedRecallAttemptRecord &&
          other.id == this.id &&
          other.passageId == this.passageId &&
          other.immediateSessionId == this.immediateSessionId &&
          other.immediateQuizResultId == this.immediateQuizResultId &&
          other.recallCompletedAt == this.recallCompletedAt &&
          other.immediateAttemptCompletedAt ==
              this.immediateAttemptCompletedAt &&
          other.dueAt == this.dueAt &&
          other.score == this.score);
}

class DelayedRecallAttemptRecordsCompanion
    extends UpdateCompanion<DelayedRecallAttemptRecord> {
  final Value<String> id;
  final Value<String> passageId;
  final Value<String?> immediateSessionId;
  final Value<String?> immediateQuizResultId;
  final Value<DateTime> recallCompletedAt;
  final Value<DateTime?> immediateAttemptCompletedAt;
  final Value<DateTime?> dueAt;
  final Value<double> score;
  final Value<int> rowid;
  const DelayedRecallAttemptRecordsCompanion({
    this.id = const Value.absent(),
    this.passageId = const Value.absent(),
    this.immediateSessionId = const Value.absent(),
    this.immediateQuizResultId = const Value.absent(),
    this.recallCompletedAt = const Value.absent(),
    this.immediateAttemptCompletedAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.score = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DelayedRecallAttemptRecordsCompanion.insert({
    required String id,
    required String passageId,
    this.immediateSessionId = const Value.absent(),
    this.immediateQuizResultId = const Value.absent(),
    required DateTime recallCompletedAt,
    this.immediateAttemptCompletedAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    required double score,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        passageId = Value(passageId),
        recallCompletedAt = Value(recallCompletedAt),
        score = Value(score);
  static Insertable<DelayedRecallAttemptRecord> custom({
    Expression<String>? id,
    Expression<String>? passageId,
    Expression<String>? immediateSessionId,
    Expression<String>? immediateQuizResultId,
    Expression<DateTime>? recallCompletedAt,
    Expression<DateTime>? immediateAttemptCompletedAt,
    Expression<DateTime>? dueAt,
    Expression<double>? score,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (passageId != null) 'passage_id': passageId,
      if (immediateSessionId != null)
        'immediate_session_id': immediateSessionId,
      if (immediateQuizResultId != null)
        'immediate_quiz_result_id': immediateQuizResultId,
      if (recallCompletedAt != null) 'recall_completed_at': recallCompletedAt,
      if (immediateAttemptCompletedAt != null)
        'immediate_attempt_completed_at': immediateAttemptCompletedAt,
      if (dueAt != null) 'due_at': dueAt,
      if (score != null) 'score': score,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DelayedRecallAttemptRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? passageId,
      Value<String?>? immediateSessionId,
      Value<String?>? immediateQuizResultId,
      Value<DateTime>? recallCompletedAt,
      Value<DateTime?>? immediateAttemptCompletedAt,
      Value<DateTime?>? dueAt,
      Value<double>? score,
      Value<int>? rowid}) {
    return DelayedRecallAttemptRecordsCompanion(
      id: id ?? this.id,
      passageId: passageId ?? this.passageId,
      immediateSessionId: immediateSessionId ?? this.immediateSessionId,
      immediateQuizResultId:
          immediateQuizResultId ?? this.immediateQuizResultId,
      recallCompletedAt: recallCompletedAt ?? this.recallCompletedAt,
      immediateAttemptCompletedAt:
          immediateAttemptCompletedAt ?? this.immediateAttemptCompletedAt,
      dueAt: dueAt ?? this.dueAt,
      score: score ?? this.score,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (passageId.present) {
      map['passage_id'] = Variable<String>(passageId.value);
    }
    if (immediateSessionId.present) {
      map['immediate_session_id'] = Variable<String>(immediateSessionId.value);
    }
    if (immediateQuizResultId.present) {
      map['immediate_quiz_result_id'] =
          Variable<String>(immediateQuizResultId.value);
    }
    if (recallCompletedAt.present) {
      map['recall_completed_at'] = Variable<DateTime>(recallCompletedAt.value);
    }
    if (immediateAttemptCompletedAt.present) {
      map['immediate_attempt_completed_at'] =
          Variable<DateTime>(immediateAttemptCompletedAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DelayedRecallAttemptRecordsCompanion(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('immediateSessionId: $immediateSessionId, ')
          ..write('immediateQuizResultId: $immediateQuizResultId, ')
          ..write('recallCompletedAt: $recallCompletedAt, ')
          ..write('immediateAttemptCompletedAt: $immediateAttemptCompletedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('score: $score, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressSnapshotRecordsTable extends ProgressSnapshotRecords
    with TableInfo<$ProgressSnapshotRecordsTable, ProgressSnapshotRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressSnapshotRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _latestWpmMeta =
      const VerificationMeta('latestWpm');
  @override
  late final GeneratedColumn<double> latestWpm = GeneratedColumn<double>(
      'latest_wpm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _latestComprehensionMeta =
      const VerificationMeta('latestComprehension');
  @override
  late final GeneratedColumn<double> latestComprehension =
      GeneratedColumn<double>('latest_comprehension', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _effectiveReadingScoreMeta =
      const VerificationMeta('effectiveReadingScore');
  @override
  late final GeneratedColumn<double> effectiveReadingScore =
      GeneratedColumn<double>('effective_reading_score', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _readinessPercentMeta =
      const VerificationMeta('readinessPercent');
  @override
  late final GeneratedColumn<double> readinessPercent = GeneratedColumn<double>(
      'readiness_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _streakDaysMeta =
      const VerificationMeta('streakDays');
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
      'streak_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        latestWpm,
        latestComprehension,
        effectiveReadingScore,
        readinessPercent,
        level,
        streakDays
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_snapshot_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProgressSnapshotRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('latest_wpm')) {
      context.handle(_latestWpmMeta,
          latestWpm.isAcceptableOrUnknown(data['latest_wpm']!, _latestWpmMeta));
    } else if (isInserting) {
      context.missing(_latestWpmMeta);
    }
    if (data.containsKey('latest_comprehension')) {
      context.handle(
          _latestComprehensionMeta,
          latestComprehension.isAcceptableOrUnknown(
              data['latest_comprehension']!, _latestComprehensionMeta));
    } else if (isInserting) {
      context.missing(_latestComprehensionMeta);
    }
    if (data.containsKey('effective_reading_score')) {
      context.handle(
          _effectiveReadingScoreMeta,
          effectiveReadingScore.isAcceptableOrUnknown(
              data['effective_reading_score']!, _effectiveReadingScoreMeta));
    } else if (isInserting) {
      context.missing(_effectiveReadingScoreMeta);
    }
    if (data.containsKey('readiness_percent')) {
      context.handle(
          _readinessPercentMeta,
          readinessPercent.isAcceptableOrUnknown(
              data['readiness_percent']!, _readinessPercentMeta));
    } else if (isInserting) {
      context.missing(_readinessPercentMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('streak_days')) {
      context.handle(
          _streakDaysMeta,
          streakDays.isAcceptableOrUnknown(
              data['streak_days']!, _streakDaysMeta));
    } else if (isInserting) {
      context.missing(_streakDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressSnapshotRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressSnapshotRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      latestWpm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latest_wpm'])!,
      latestComprehension: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}latest_comprehension'])!,
      effectiveReadingScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}effective_reading_score'])!,
      readinessPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}readiness_percent'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      streakDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_days'])!,
    );
  }

  @override
  $ProgressSnapshotRecordsTable createAlias(String alias) {
    return $ProgressSnapshotRecordsTable(attachedDatabase, alias);
  }
}

class ProgressSnapshotRecord extends DataClass
    implements Insertable<ProgressSnapshotRecord> {
  final String id;
  final DateTime createdAt;
  final double latestWpm;
  final double latestComprehension;
  final double effectiveReadingScore;
  final double readinessPercent;
  final int level;
  final int streakDays;
  const ProgressSnapshotRecord(
      {required this.id,
      required this.createdAt,
      required this.latestWpm,
      required this.latestComprehension,
      required this.effectiveReadingScore,
      required this.readinessPercent,
      required this.level,
      required this.streakDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['latest_wpm'] = Variable<double>(latestWpm);
    map['latest_comprehension'] = Variable<double>(latestComprehension);
    map['effective_reading_score'] = Variable<double>(effectiveReadingScore);
    map['readiness_percent'] = Variable<double>(readinessPercent);
    map['level'] = Variable<int>(level);
    map['streak_days'] = Variable<int>(streakDays);
    return map;
  }

  ProgressSnapshotRecordsCompanion toCompanion(bool nullToAbsent) {
    return ProgressSnapshotRecordsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      latestWpm: Value(latestWpm),
      latestComprehension: Value(latestComprehension),
      effectiveReadingScore: Value(effectiveReadingScore),
      readinessPercent: Value(readinessPercent),
      level: Value(level),
      streakDays: Value(streakDays),
    );
  }

  factory ProgressSnapshotRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressSnapshotRecord(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      latestWpm: serializer.fromJson<double>(json['latestWpm']),
      latestComprehension:
          serializer.fromJson<double>(json['latestComprehension']),
      effectiveReadingScore:
          serializer.fromJson<double>(json['effectiveReadingScore']),
      readinessPercent: serializer.fromJson<double>(json['readinessPercent']),
      level: serializer.fromJson<int>(json['level']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'latestWpm': serializer.toJson<double>(latestWpm),
      'latestComprehension': serializer.toJson<double>(latestComprehension),
      'effectiveReadingScore': serializer.toJson<double>(effectiveReadingScore),
      'readinessPercent': serializer.toJson<double>(readinessPercent),
      'level': serializer.toJson<int>(level),
      'streakDays': serializer.toJson<int>(streakDays),
    };
  }

  ProgressSnapshotRecord copyWith(
          {String? id,
          DateTime? createdAt,
          double? latestWpm,
          double? latestComprehension,
          double? effectiveReadingScore,
          double? readinessPercent,
          int? level,
          int? streakDays}) =>
      ProgressSnapshotRecord(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        latestWpm: latestWpm ?? this.latestWpm,
        latestComprehension: latestComprehension ?? this.latestComprehension,
        effectiveReadingScore:
            effectiveReadingScore ?? this.effectiveReadingScore,
        readinessPercent: readinessPercent ?? this.readinessPercent,
        level: level ?? this.level,
        streakDays: streakDays ?? this.streakDays,
      );
  ProgressSnapshotRecord copyWithCompanion(
      ProgressSnapshotRecordsCompanion data) {
    return ProgressSnapshotRecord(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      latestWpm: data.latestWpm.present ? data.latestWpm.value : this.latestWpm,
      latestComprehension: data.latestComprehension.present
          ? data.latestComprehension.value
          : this.latestComprehension,
      effectiveReadingScore: data.effectiveReadingScore.present
          ? data.effectiveReadingScore.value
          : this.effectiveReadingScore,
      readinessPercent: data.readinessPercent.present
          ? data.readinessPercent.value
          : this.readinessPercent,
      level: data.level.present ? data.level.value : this.level,
      streakDays:
          data.streakDays.present ? data.streakDays.value : this.streakDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressSnapshotRecord(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('latestWpm: $latestWpm, ')
          ..write('latestComprehension: $latestComprehension, ')
          ..write('effectiveReadingScore: $effectiveReadingScore, ')
          ..write('readinessPercent: $readinessPercent, ')
          ..write('level: $level, ')
          ..write('streakDays: $streakDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, latestWpm, latestComprehension,
      effectiveReadingScore, readinessPercent, level, streakDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressSnapshotRecord &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.latestWpm == this.latestWpm &&
          other.latestComprehension == this.latestComprehension &&
          other.effectiveReadingScore == this.effectiveReadingScore &&
          other.readinessPercent == this.readinessPercent &&
          other.level == this.level &&
          other.streakDays == this.streakDays);
}

class ProgressSnapshotRecordsCompanion
    extends UpdateCompanion<ProgressSnapshotRecord> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<double> latestWpm;
  final Value<double> latestComprehension;
  final Value<double> effectiveReadingScore;
  final Value<double> readinessPercent;
  final Value<int> level;
  final Value<int> streakDays;
  final Value<int> rowid;
  const ProgressSnapshotRecordsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.latestWpm = const Value.absent(),
    this.latestComprehension = const Value.absent(),
    this.effectiveReadingScore = const Value.absent(),
    this.readinessPercent = const Value.absent(),
    this.level = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressSnapshotRecordsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required double latestWpm,
    required double latestComprehension,
    required double effectiveReadingScore,
    required double readinessPercent,
    required int level,
    required int streakDays,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        latestWpm = Value(latestWpm),
        latestComprehension = Value(latestComprehension),
        effectiveReadingScore = Value(effectiveReadingScore),
        readinessPercent = Value(readinessPercent),
        level = Value(level),
        streakDays = Value(streakDays);
  static Insertable<ProgressSnapshotRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<double>? latestWpm,
    Expression<double>? latestComprehension,
    Expression<double>? effectiveReadingScore,
    Expression<double>? readinessPercent,
    Expression<int>? level,
    Expression<int>? streakDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (latestWpm != null) 'latest_wpm': latestWpm,
      if (latestComprehension != null)
        'latest_comprehension': latestComprehension,
      if (effectiveReadingScore != null)
        'effective_reading_score': effectiveReadingScore,
      if (readinessPercent != null) 'readiness_percent': readinessPercent,
      if (level != null) 'level': level,
      if (streakDays != null) 'streak_days': streakDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressSnapshotRecordsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<double>? latestWpm,
      Value<double>? latestComprehension,
      Value<double>? effectiveReadingScore,
      Value<double>? readinessPercent,
      Value<int>? level,
      Value<int>? streakDays,
      Value<int>? rowid}) {
    return ProgressSnapshotRecordsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      latestWpm: latestWpm ?? this.latestWpm,
      latestComprehension: latestComprehension ?? this.latestComprehension,
      effectiveReadingScore:
          effectiveReadingScore ?? this.effectiveReadingScore,
      readinessPercent: readinessPercent ?? this.readinessPercent,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (latestWpm.present) {
      map['latest_wpm'] = Variable<double>(latestWpm.value);
    }
    if (latestComprehension.present) {
      map['latest_comprehension'] = Variable<double>(latestComprehension.value);
    }
    if (effectiveReadingScore.present) {
      map['effective_reading_score'] =
          Variable<double>(effectiveReadingScore.value);
    }
    if (readinessPercent.present) {
      map['readiness_percent'] = Variable<double>(readinessPercent.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressSnapshotRecordsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('latestWpm: $latestWpm, ')
          ..write('latestComprehension: $latestComprehension, ')
          ..write('effectiveReadingScore: $effectiveReadingScore, ')
          ..write('readinessPercent: $readinessPercent, ')
          ..write('level: $level, ')
          ..write('streakDays: $streakDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CertificationAttemptRecordsTable extends CertificationAttemptRecords
    with
        TableInfo<$CertificationAttemptRecordsTable,
            CertificationAttemptRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CertificationAttemptRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdsJsonMeta =
      const VerificationMeta('sessionIdsJson');
  @override
  late final GeneratedColumn<String> sessionIdsJson = GeneratedColumn<String>(
      'session_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isCertifiedMeta =
      const VerificationMeta('isCertified');
  @override
  late final GeneratedColumn<bool> isCertified = GeneratedColumn<bool>(
      'is_certified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_certified" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionIdsJson, startedAt, completedAt, isCertified];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'certification_attempt_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<CertificationAttemptRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_ids_json')) {
      context.handle(
          _sessionIdsJsonMeta,
          sessionIdsJson.isAcceptableOrUnknown(
              data['session_ids_json']!, _sessionIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_sessionIdsJsonMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('is_certified')) {
      context.handle(
          _isCertifiedMeta,
          isCertified.isAcceptableOrUnknown(
              data['is_certified']!, _isCertifiedMeta));
    } else if (isInserting) {
      context.missing(_isCertifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CertificationAttemptRecord map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CertificationAttemptRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}session_ids_json'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      isCertified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_certified'])!,
    );
  }

  @override
  $CertificationAttemptRecordsTable createAlias(String alias) {
    return $CertificationAttemptRecordsTable(attachedDatabase, alias);
  }
}

class CertificationAttemptRecord extends DataClass
    implements Insertable<CertificationAttemptRecord> {
  final String id;
  final String sessionIdsJson;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCertified;
  const CertificationAttemptRecord(
      {required this.id,
      required this.sessionIdsJson,
      required this.startedAt,
      this.completedAt,
      required this.isCertified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_ids_json'] = Variable<String>(sessionIdsJson);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['is_certified'] = Variable<bool>(isCertified);
    return map;
  }

  CertificationAttemptRecordsCompanion toCompanion(bool nullToAbsent) {
    return CertificationAttemptRecordsCompanion(
      id: Value(id),
      sessionIdsJson: Value(sessionIdsJson),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      isCertified: Value(isCertified),
    );
  }

  factory CertificationAttemptRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CertificationAttemptRecord(
      id: serializer.fromJson<String>(json['id']),
      sessionIdsJson: serializer.fromJson<String>(json['sessionIdsJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      isCertified: serializer.fromJson<bool>(json['isCertified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionIdsJson': serializer.toJson<String>(sessionIdsJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'isCertified': serializer.toJson<bool>(isCertified),
    };
  }

  CertificationAttemptRecord copyWith(
          {String? id,
          String? sessionIdsJson,
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          bool? isCertified}) =>
      CertificationAttemptRecord(
        id: id ?? this.id,
        sessionIdsJson: sessionIdsJson ?? this.sessionIdsJson,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        isCertified: isCertified ?? this.isCertified,
      );
  CertificationAttemptRecord copyWithCompanion(
      CertificationAttemptRecordsCompanion data) {
    return CertificationAttemptRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionIdsJson: data.sessionIdsJson.present
          ? data.sessionIdsJson.value
          : this.sessionIdsJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      isCertified:
          data.isCertified.present ? data.isCertified.value : this.isCertified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CertificationAttemptRecord(')
          ..write('id: $id, ')
          ..write('sessionIdsJson: $sessionIdsJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('isCertified: $isCertified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionIdsJson, startedAt, completedAt, isCertified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CertificationAttemptRecord &&
          other.id == this.id &&
          other.sessionIdsJson == this.sessionIdsJson &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.isCertified == this.isCertified);
}

class CertificationAttemptRecordsCompanion
    extends UpdateCompanion<CertificationAttemptRecord> {
  final Value<String> id;
  final Value<String> sessionIdsJson;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<bool> isCertified;
  final Value<int> rowid;
  const CertificationAttemptRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionIdsJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isCertified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CertificationAttemptRecordsCompanion.insert({
    required String id,
    required String sessionIdsJson,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required bool isCertified,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionIdsJson = Value(sessionIdsJson),
        startedAt = Value(startedAt),
        isCertified = Value(isCertified);
  static Insertable<CertificationAttemptRecord> custom({
    Expression<String>? id,
    Expression<String>? sessionIdsJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<bool>? isCertified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionIdsJson != null) 'session_ids_json': sessionIdsJson,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (isCertified != null) 'is_certified': isCertified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CertificationAttemptRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionIdsJson,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<bool>? isCertified,
      Value<int>? rowid}) {
    return CertificationAttemptRecordsCompanion(
      id: id ?? this.id,
      sessionIdsJson: sessionIdsJson ?? this.sessionIdsJson,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCertified: isCertified ?? this.isCertified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionIdsJson.present) {
      map['session_ids_json'] = Variable<String>(sessionIdsJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (isCertified.present) {
      map['is_certified'] = Variable<bool>(isCertified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CertificationAttemptRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionIdsJson: $sessionIdsJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('isCertified: $isCertified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasteryAttemptRecordsTable extends MasteryAttemptRecords
    with TableInfo<$MasteryAttemptRecordsTable, MasteryAttemptRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasteryAttemptRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdsJsonMeta =
      const VerificationMeta('sessionIdsJson');
  @override
  late final GeneratedColumn<String> sessionIdsJson = GeneratedColumn<String>(
      'session_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _delayedRecallQuizResultIdsJsonMeta =
      const VerificationMeta('delayedRecallQuizResultIdsJson');
  @override
  late final GeneratedColumn<String> delayedRecallQuizResultIdsJson =
      GeneratedColumn<String>(
          'delayed_recall_quiz_result_ids_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isMasteredMeta =
      const VerificationMeta('isMastered');
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
      'is_mastered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_mastered" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionIdsJson,
        delayedRecallQuizResultIdsJson,
        startedAt,
        completedAt,
        isMastered
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mastery_attempt_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<MasteryAttemptRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_ids_json')) {
      context.handle(
          _sessionIdsJsonMeta,
          sessionIdsJson.isAcceptableOrUnknown(
              data['session_ids_json']!, _sessionIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_sessionIdsJsonMeta);
    }
    if (data.containsKey('delayed_recall_quiz_result_ids_json')) {
      context.handle(
          _delayedRecallQuizResultIdsJsonMeta,
          delayedRecallQuizResultIdsJson.isAcceptableOrUnknown(
              data['delayed_recall_quiz_result_ids_json']!,
              _delayedRecallQuizResultIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_delayedRecallQuizResultIdsJsonMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
          _isMasteredMeta,
          isMastered.isAcceptableOrUnknown(
              data['is_mastered']!, _isMasteredMeta));
    } else if (isInserting) {
      context.missing(_isMasteredMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasteryAttemptRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasteryAttemptRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}session_ids_json'])!,
      delayedRecallQuizResultIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}delayed_recall_quiz_result_ids_json'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      isMastered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_mastered'])!,
    );
  }

  @override
  $MasteryAttemptRecordsTable createAlias(String alias) {
    return $MasteryAttemptRecordsTable(attachedDatabase, alias);
  }
}

class MasteryAttemptRecord extends DataClass
    implements Insertable<MasteryAttemptRecord> {
  final String id;
  final String sessionIdsJson;
  final String delayedRecallQuizResultIdsJson;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isMastered;
  const MasteryAttemptRecord(
      {required this.id,
      required this.sessionIdsJson,
      required this.delayedRecallQuizResultIdsJson,
      required this.startedAt,
      this.completedAt,
      required this.isMastered});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_ids_json'] = Variable<String>(sessionIdsJson);
    map['delayed_recall_quiz_result_ids_json'] =
        Variable<String>(delayedRecallQuizResultIdsJson);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['is_mastered'] = Variable<bool>(isMastered);
    return map;
  }

  MasteryAttemptRecordsCompanion toCompanion(bool nullToAbsent) {
    return MasteryAttemptRecordsCompanion(
      id: Value(id),
      sessionIdsJson: Value(sessionIdsJson),
      delayedRecallQuizResultIdsJson: Value(delayedRecallQuizResultIdsJson),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      isMastered: Value(isMastered),
    );
  }

  factory MasteryAttemptRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasteryAttemptRecord(
      id: serializer.fromJson<String>(json['id']),
      sessionIdsJson: serializer.fromJson<String>(json['sessionIdsJson']),
      delayedRecallQuizResultIdsJson:
          serializer.fromJson<String>(json['delayedRecallQuizResultIdsJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionIdsJson': serializer.toJson<String>(sessionIdsJson),
      'delayedRecallQuizResultIdsJson':
          serializer.toJson<String>(delayedRecallQuizResultIdsJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'isMastered': serializer.toJson<bool>(isMastered),
    };
  }

  MasteryAttemptRecord copyWith(
          {String? id,
          String? sessionIdsJson,
          String? delayedRecallQuizResultIdsJson,
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          bool? isMastered}) =>
      MasteryAttemptRecord(
        id: id ?? this.id,
        sessionIdsJson: sessionIdsJson ?? this.sessionIdsJson,
        delayedRecallQuizResultIdsJson: delayedRecallQuizResultIdsJson ??
            this.delayedRecallQuizResultIdsJson,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        isMastered: isMastered ?? this.isMastered,
      );
  MasteryAttemptRecord copyWithCompanion(MasteryAttemptRecordsCompanion data) {
    return MasteryAttemptRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionIdsJson: data.sessionIdsJson.present
          ? data.sessionIdsJson.value
          : this.sessionIdsJson,
      delayedRecallQuizResultIdsJson:
          data.delayedRecallQuizResultIdsJson.present
              ? data.delayedRecallQuizResultIdsJson.value
              : this.delayedRecallQuizResultIdsJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      isMastered:
          data.isMastered.present ? data.isMastered.value : this.isMastered,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasteryAttemptRecord(')
          ..write('id: $id, ')
          ..write('sessionIdsJson: $sessionIdsJson, ')
          ..write(
              'delayedRecallQuizResultIdsJson: $delayedRecallQuizResultIdsJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('isMastered: $isMastered')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionIdsJson,
      delayedRecallQuizResultIdsJson, startedAt, completedAt, isMastered);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasteryAttemptRecord &&
          other.id == this.id &&
          other.sessionIdsJson == this.sessionIdsJson &&
          other.delayedRecallQuizResultIdsJson ==
              this.delayedRecallQuizResultIdsJson &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.isMastered == this.isMastered);
}

class MasteryAttemptRecordsCompanion
    extends UpdateCompanion<MasteryAttemptRecord> {
  final Value<String> id;
  final Value<String> sessionIdsJson;
  final Value<String> delayedRecallQuizResultIdsJson;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<bool> isMastered;
  final Value<int> rowid;
  const MasteryAttemptRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionIdsJson = const Value.absent(),
    this.delayedRecallQuizResultIdsJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasteryAttemptRecordsCompanion.insert({
    required String id,
    required String sessionIdsJson,
    required String delayedRecallQuizResultIdsJson,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required bool isMastered,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionIdsJson = Value(sessionIdsJson),
        delayedRecallQuizResultIdsJson = Value(delayedRecallQuizResultIdsJson),
        startedAt = Value(startedAt),
        isMastered = Value(isMastered);
  static Insertable<MasteryAttemptRecord> custom({
    Expression<String>? id,
    Expression<String>? sessionIdsJson,
    Expression<String>? delayedRecallQuizResultIdsJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<bool>? isMastered,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionIdsJson != null) 'session_ids_json': sessionIdsJson,
      if (delayedRecallQuizResultIdsJson != null)
        'delayed_recall_quiz_result_ids_json': delayedRecallQuizResultIdsJson,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (isMastered != null) 'is_mastered': isMastered,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasteryAttemptRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionIdsJson,
      Value<String>? delayedRecallQuizResultIdsJson,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<bool>? isMastered,
      Value<int>? rowid}) {
    return MasteryAttemptRecordsCompanion(
      id: id ?? this.id,
      sessionIdsJson: sessionIdsJson ?? this.sessionIdsJson,
      delayedRecallQuizResultIdsJson:
          delayedRecallQuizResultIdsJson ?? this.delayedRecallQuizResultIdsJson,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isMastered: isMastered ?? this.isMastered,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionIdsJson.present) {
      map['session_ids_json'] = Variable<String>(sessionIdsJson.value);
    }
    if (delayedRecallQuizResultIdsJson.present) {
      map['delayed_recall_quiz_result_ids_json'] =
          Variable<String>(delayedRecallQuizResultIdsJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasteryAttemptRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionIdsJson: $sessionIdsJson, ')
          ..write(
              'delayedRecallQuizResultIdsJson: $delayedRecallQuizResultIdsJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('isMastered: $isMastered, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $PassageRecordsTable passageRecords = $PassageRecordsTable(this);
  late final $ReadingSessionRecordsTable readingSessionRecords =
      $ReadingSessionRecordsTable(this);
  late final $QuizResultRecordsTable quizResultRecords =
      $QuizResultRecordsTable(this);
  late final $DelayedRecallAttemptRecordsTable delayedRecallAttemptRecords =
      $DelayedRecallAttemptRecordsTable(this);
  late final $ProgressSnapshotRecordsTable progressSnapshotRecords =
      $ProgressSnapshotRecordsTable(this);
  late final $CertificationAttemptRecordsTable certificationAttemptRecords =
      $CertificationAttemptRecordsTable(this);
  late final $MasteryAttemptRecordsTable masteryAttemptRecords =
      $MasteryAttemptRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        localProfiles,
        passageRecords,
        readingSessionRecords,
        quizResultRecords,
        delayedRecallAttemptRecords,
        progressSnapshotRecords,
        certificationAttemptRecords,
        masteryAttemptRecords
      ];
}

typedef $$LocalProfilesTableCreateCompanionBuilder = LocalProfilesCompanion
    Function({
  required String id,
  required DateTime createdAt,
  required String goalsJson,
  required double preferredFontSize,
  required double preferredLineHeight,
  Value<double> preferredColumnWidth,
  Value<String> preferredThemeMode,
  required bool reducedMotion,
  Value<double?> baselineWpm,
  Value<double?> baselineComprehension,
  Value<double?> baselineEffectiveReadingScore,
  Value<int> rowid,
});
typedef $$LocalProfilesTableUpdateCompanionBuilder = LocalProfilesCompanion
    Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<String> goalsJson,
  Value<double> preferredFontSize,
  Value<double> preferredLineHeight,
  Value<double> preferredColumnWidth,
  Value<String> preferredThemeMode,
  Value<bool> reducedMotion,
  Value<double?> baselineWpm,
  Value<double?> baselineComprehension,
  Value<double?> baselineEffectiveReadingScore,
  Value<int> rowid,
});

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalsJson => $composableBuilder(
      column: $table.goalsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get preferredFontSize => $composableBuilder(
      column: $table.preferredFontSize,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get preferredLineHeight => $composableBuilder(
      column: $table.preferredLineHeight,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get preferredColumnWidth => $composableBuilder(
      column: $table.preferredColumnWidth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredThemeMode => $composableBuilder(
      column: $table.preferredThemeMode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reducedMotion => $composableBuilder(
      column: $table.reducedMotion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baselineWpm => $composableBuilder(
      column: $table.baselineWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baselineComprehension => $composableBuilder(
      column: $table.baselineComprehension,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baselineEffectiveReadingScore => $composableBuilder(
      column: $table.baselineEffectiveReadingScore,
      builder: (column) => ColumnFilters(column));
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalsJson => $composableBuilder(
      column: $table.goalsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get preferredFontSize => $composableBuilder(
      column: $table.preferredFontSize,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get preferredLineHeight => $composableBuilder(
      column: $table.preferredLineHeight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get preferredColumnWidth => $composableBuilder(
      column: $table.preferredColumnWidth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredThemeMode => $composableBuilder(
      column: $table.preferredThemeMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reducedMotion => $composableBuilder(
      column: $table.reducedMotion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baselineWpm => $composableBuilder(
      column: $table.baselineWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baselineComprehension => $composableBuilder(
      column: $table.baselineComprehension,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baselineEffectiveReadingScore =>
      $composableBuilder(
          column: $table.baselineEffectiveReadingScore,
          builder: (column) => ColumnOrderings(column));
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get goalsJson =>
      $composableBuilder(column: $table.goalsJson, builder: (column) => column);

  GeneratedColumn<double> get preferredFontSize => $composableBuilder(
      column: $table.preferredFontSize, builder: (column) => column);

  GeneratedColumn<double> get preferredLineHeight => $composableBuilder(
      column: $table.preferredLineHeight, builder: (column) => column);

  GeneratedColumn<double> get preferredColumnWidth => $composableBuilder(
      column: $table.preferredColumnWidth, builder: (column) => column);

  GeneratedColumn<String> get preferredThemeMode => $composableBuilder(
      column: $table.preferredThemeMode, builder: (column) => column);

  GeneratedColumn<bool> get reducedMotion => $composableBuilder(
      column: $table.reducedMotion, builder: (column) => column);

  GeneratedColumn<double> get baselineWpm => $composableBuilder(
      column: $table.baselineWpm, builder: (column) => column);

  GeneratedColumn<double> get baselineComprehension => $composableBuilder(
      column: $table.baselineComprehension, builder: (column) => column);

  GeneratedColumn<double> get baselineEffectiveReadingScore =>
      $composableBuilder(
          column: $table.baselineEffectiveReadingScore,
          builder: (column) => column);
}

class $$LocalProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalProfilesTable,
    LocalProfile,
    $$LocalProfilesTableFilterComposer,
    $$LocalProfilesTableOrderingComposer,
    $$LocalProfilesTableAnnotationComposer,
    $$LocalProfilesTableCreateCompanionBuilder,
    $$LocalProfilesTableUpdateCompanionBuilder,
    (
      LocalProfile,
      BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>
    ),
    LocalProfile,
    PrefetchHooks Function()> {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> goalsJson = const Value.absent(),
            Value<double> preferredFontSize = const Value.absent(),
            Value<double> preferredLineHeight = const Value.absent(),
            Value<double> preferredColumnWidth = const Value.absent(),
            Value<String> preferredThemeMode = const Value.absent(),
            Value<bool> reducedMotion = const Value.absent(),
            Value<double?> baselineWpm = const Value.absent(),
            Value<double?> baselineComprehension = const Value.absent(),
            Value<double?> baselineEffectiveReadingScore = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProfilesCompanion(
            id: id,
            createdAt: createdAt,
            goalsJson: goalsJson,
            preferredFontSize: preferredFontSize,
            preferredLineHeight: preferredLineHeight,
            preferredColumnWidth: preferredColumnWidth,
            preferredThemeMode: preferredThemeMode,
            reducedMotion: reducedMotion,
            baselineWpm: baselineWpm,
            baselineComprehension: baselineComprehension,
            baselineEffectiveReadingScore: baselineEffectiveReadingScore,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime createdAt,
            required String goalsJson,
            required double preferredFontSize,
            required double preferredLineHeight,
            Value<double> preferredColumnWidth = const Value.absent(),
            Value<String> preferredThemeMode = const Value.absent(),
            required bool reducedMotion,
            Value<double?> baselineWpm = const Value.absent(),
            Value<double?> baselineComprehension = const Value.absent(),
            Value<double?> baselineEffectiveReadingScore = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProfilesCompanion.insert(
            id: id,
            createdAt: createdAt,
            goalsJson: goalsJson,
            preferredFontSize: preferredFontSize,
            preferredLineHeight: preferredLineHeight,
            preferredColumnWidth: preferredColumnWidth,
            preferredThemeMode: preferredThemeMode,
            reducedMotion: reducedMotion,
            baselineWpm: baselineWpm,
            baselineComprehension: baselineComprehension,
            baselineEffectiveReadingScore: baselineEffectiveReadingScore,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalProfilesTable,
    LocalProfile,
    $$LocalProfilesTableFilterComposer,
    $$LocalProfilesTableOrderingComposer,
    $$LocalProfilesTableAnnotationComposer,
    $$LocalProfilesTableCreateCompanionBuilder,
    $$LocalProfilesTableUpdateCompanionBuilder,
    (
      LocalProfile,
      BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>
    ),
    LocalProfile,
    PrefetchHooks Function()>;
typedef $$PassageRecordsTableCreateCompanionBuilder = PassageRecordsCompanion
    Function({
  required String id,
  required String title,
  required String body,
  required String source,
  required String metadataJson,
  Value<int> rowid,
});
typedef $$PassageRecordsTableUpdateCompanionBuilder = PassageRecordsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> body,
  Value<String> source,
  Value<String> metadataJson,
  Value<int> rowid,
});

class $$PassageRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PassageRecordsTable> {
  $$PassageRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));
}

class $$PassageRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PassageRecordsTable> {
  $$PassageRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));
}

class $$PassageRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PassageRecordsTable> {
  $$PassageRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);
}

class $$PassageRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PassageRecordsTable,
    PassageRecord,
    $$PassageRecordsTableFilterComposer,
    $$PassageRecordsTableOrderingComposer,
    $$PassageRecordsTableAnnotationComposer,
    $$PassageRecordsTableCreateCompanionBuilder,
    $$PassageRecordsTableUpdateCompanionBuilder,
    (
      PassageRecord,
      BaseReferences<_$AppDatabase, $PassageRecordsTable, PassageRecord>
    ),
    PassageRecord,
    PrefetchHooks Function()> {
  $$PassageRecordsTableTableManager(
      _$AppDatabase db, $PassageRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PassageRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PassageRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PassageRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PassageRecordsCompanion(
            id: id,
            title: title,
            body: body,
            source: source,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String body,
            required String source,
            required String metadataJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              PassageRecordsCompanion.insert(
            id: id,
            title: title,
            body: body,
            source: source,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PassageRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PassageRecordsTable,
    PassageRecord,
    $$PassageRecordsTableFilterComposer,
    $$PassageRecordsTableOrderingComposer,
    $$PassageRecordsTableAnnotationComposer,
    $$PassageRecordsTableCreateCompanionBuilder,
    $$PassageRecordsTableUpdateCompanionBuilder,
    (
      PassageRecord,
      BaseReferences<_$AppDatabase, $PassageRecordsTable, PassageRecord>
    ),
    PassageRecord,
    PrefetchHooks Function()>;
typedef $$ReadingSessionRecordsTableCreateCompanionBuilder
    = ReadingSessionRecordsCompanion Function({
  required String id,
  required String passageId,
  required String mode,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  required int activeReadingSeconds,
  required int wordCount,
  required String status,
  Value<int?> targetWpm,
  required int pauseCount,
  Value<int?> userConfidenceRating,
  Value<int?> selfRatedFocus,
  Value<int> rowid,
});
typedef $$ReadingSessionRecordsTableUpdateCompanionBuilder
    = ReadingSessionRecordsCompanion Function({
  Value<String> id,
  Value<String> passageId,
  Value<String> mode,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int> activeReadingSeconds,
  Value<int> wordCount,
  Value<String> status,
  Value<int?> targetWpm,
  Value<int> pauseCount,
  Value<int?> userConfidenceRating,
  Value<int?> selfRatedFocus,
  Value<int> rowid,
});

class $$ReadingSessionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionRecordsTable> {
  $$ReadingSessionRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passageId => $composableBuilder(
      column: $table.passageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activeReadingSeconds => $composableBuilder(
      column: $table.activeReadingSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordCount => $composableBuilder(
      column: $table.wordCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetWpm => $composableBuilder(
      column: $table.targetWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pauseCount => $composableBuilder(
      column: $table.pauseCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userConfidenceRating => $composableBuilder(
      column: $table.userConfidenceRating,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get selfRatedFocus => $composableBuilder(
      column: $table.selfRatedFocus,
      builder: (column) => ColumnFilters(column));
}

class $$ReadingSessionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionRecordsTable> {
  $$ReadingSessionRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passageId => $composableBuilder(
      column: $table.passageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activeReadingSeconds => $composableBuilder(
      column: $table.activeReadingSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordCount => $composableBuilder(
      column: $table.wordCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetWpm => $composableBuilder(
      column: $table.targetWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pauseCount => $composableBuilder(
      column: $table.pauseCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userConfidenceRating => $composableBuilder(
      column: $table.userConfidenceRating,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get selfRatedFocus => $composableBuilder(
      column: $table.selfRatedFocus,
      builder: (column) => ColumnOrderings(column));
}

class $$ReadingSessionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionRecordsTable> {
  $$ReadingSessionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get passageId =>
      $composableBuilder(column: $table.passageId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get activeReadingSeconds => $composableBuilder(
      column: $table.activeReadingSeconds, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get targetWpm =>
      $composableBuilder(column: $table.targetWpm, builder: (column) => column);

  GeneratedColumn<int> get pauseCount => $composableBuilder(
      column: $table.pauseCount, builder: (column) => column);

  GeneratedColumn<int> get userConfidenceRating => $composableBuilder(
      column: $table.userConfidenceRating, builder: (column) => column);

  GeneratedColumn<int> get selfRatedFocus => $composableBuilder(
      column: $table.selfRatedFocus, builder: (column) => column);
}

class $$ReadingSessionRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadingSessionRecordsTable,
    ReadingSessionRecord,
    $$ReadingSessionRecordsTableFilterComposer,
    $$ReadingSessionRecordsTableOrderingComposer,
    $$ReadingSessionRecordsTableAnnotationComposer,
    $$ReadingSessionRecordsTableCreateCompanionBuilder,
    $$ReadingSessionRecordsTableUpdateCompanionBuilder,
    (
      ReadingSessionRecord,
      BaseReferences<_$AppDatabase, $ReadingSessionRecordsTable,
          ReadingSessionRecord>
    ),
    ReadingSessionRecord,
    PrefetchHooks Function()> {
  $$ReadingSessionRecordsTableTableManager(
      _$AppDatabase db, $ReadingSessionRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionRecordsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSessionRecordsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSessionRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> passageId = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> activeReadingSeconds = const Value.absent(),
            Value<int> wordCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> targetWpm = const Value.absent(),
            Value<int> pauseCount = const Value.absent(),
            Value<int?> userConfidenceRating = const Value.absent(),
            Value<int?> selfRatedFocus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingSessionRecordsCompanion(
            id: id,
            passageId: passageId,
            mode: mode,
            startedAt: startedAt,
            completedAt: completedAt,
            activeReadingSeconds: activeReadingSeconds,
            wordCount: wordCount,
            status: status,
            targetWpm: targetWpm,
            pauseCount: pauseCount,
            userConfidenceRating: userConfidenceRating,
            selfRatedFocus: selfRatedFocus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String passageId,
            required String mode,
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required int activeReadingSeconds,
            required int wordCount,
            required String status,
            Value<int?> targetWpm = const Value.absent(),
            required int pauseCount,
            Value<int?> userConfidenceRating = const Value.absent(),
            Value<int?> selfRatedFocus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingSessionRecordsCompanion.insert(
            id: id,
            passageId: passageId,
            mode: mode,
            startedAt: startedAt,
            completedAt: completedAt,
            activeReadingSeconds: activeReadingSeconds,
            wordCount: wordCount,
            status: status,
            targetWpm: targetWpm,
            pauseCount: pauseCount,
            userConfidenceRating: userConfidenceRating,
            selfRatedFocus: selfRatedFocus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadingSessionRecordsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ReadingSessionRecordsTable,
        ReadingSessionRecord,
        $$ReadingSessionRecordsTableFilterComposer,
        $$ReadingSessionRecordsTableOrderingComposer,
        $$ReadingSessionRecordsTableAnnotationComposer,
        $$ReadingSessionRecordsTableCreateCompanionBuilder,
        $$ReadingSessionRecordsTableUpdateCompanionBuilder,
        (
          ReadingSessionRecord,
          BaseReferences<_$AppDatabase, $ReadingSessionRecordsTable,
              ReadingSessionRecord>
        ),
        ReadingSessionRecord,
        PrefetchHooks Function()>;
typedef $$QuizResultRecordsTableCreateCompanionBuilder
    = QuizResultRecordsCompanion Function({
  required String id,
  required String sessionId,
  required String passageId,
  required int correctCount,
  required int totalQuestions,
  required String answersByQuestionIdJson,
  Value<String> questionTypesByQuestionIdJson,
  required DateTime completedAt,
  Value<String?> writtenSummary,
  Value<int> rowid,
});
typedef $$QuizResultRecordsTableUpdateCompanionBuilder
    = QuizResultRecordsCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> passageId,
  Value<int> correctCount,
  Value<int> totalQuestions,
  Value<String> answersByQuestionIdJson,
  Value<String> questionTypesByQuestionIdJson,
  Value<DateTime> completedAt,
  Value<String?> writtenSummary,
  Value<int> rowid,
});

class $$QuizResultRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizResultRecordsTable> {
  $$QuizResultRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passageId => $composableBuilder(
      column: $table.passageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answersByQuestionIdJson => $composableBuilder(
      column: $table.answersByQuestionIdJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionTypesByQuestionIdJson => $composableBuilder(
      column: $table.questionTypesByQuestionIdJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get writtenSummary => $composableBuilder(
      column: $table.writtenSummary,
      builder: (column) => ColumnFilters(column));
}

class $$QuizResultRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizResultRecordsTable> {
  $$QuizResultRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passageId => $composableBuilder(
      column: $table.passageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctCount => $composableBuilder(
      column: $table.correctCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answersByQuestionIdJson => $composableBuilder(
      column: $table.answersByQuestionIdJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionTypesByQuestionIdJson =>
      $composableBuilder(
          column: $table.questionTypesByQuestionIdJson,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get writtenSummary => $composableBuilder(
      column: $table.writtenSummary,
      builder: (column) => ColumnOrderings(column));
}

class $$QuizResultRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizResultRecordsTable> {
  $$QuizResultRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get passageId =>
      $composableBuilder(column: $table.passageId, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions, builder: (column) => column);

  GeneratedColumn<String> get answersByQuestionIdJson => $composableBuilder(
      column: $table.answersByQuestionIdJson, builder: (column) => column);

  GeneratedColumn<String> get questionTypesByQuestionIdJson =>
      $composableBuilder(
          column: $table.questionTypesByQuestionIdJson,
          builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get writtenSummary => $composableBuilder(
      column: $table.writtenSummary, builder: (column) => column);
}

class $$QuizResultRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuizResultRecordsTable,
    QuizResultRecord,
    $$QuizResultRecordsTableFilterComposer,
    $$QuizResultRecordsTableOrderingComposer,
    $$QuizResultRecordsTableAnnotationComposer,
    $$QuizResultRecordsTableCreateCompanionBuilder,
    $$QuizResultRecordsTableUpdateCompanionBuilder,
    (
      QuizResultRecord,
      BaseReferences<_$AppDatabase, $QuizResultRecordsTable, QuizResultRecord>
    ),
    QuizResultRecord,
    PrefetchHooks Function()> {
  $$QuizResultRecordsTableTableManager(
      _$AppDatabase db, $QuizResultRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizResultRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizResultRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizResultRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> passageId = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> totalQuestions = const Value.absent(),
            Value<String> answersByQuestionIdJson = const Value.absent(),
            Value<String> questionTypesByQuestionIdJson = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<String?> writtenSummary = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuizResultRecordsCompanion(
            id: id,
            sessionId: sessionId,
            passageId: passageId,
            correctCount: correctCount,
            totalQuestions: totalQuestions,
            answersByQuestionIdJson: answersByQuestionIdJson,
            questionTypesByQuestionIdJson: questionTypesByQuestionIdJson,
            completedAt: completedAt,
            writtenSummary: writtenSummary,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required String passageId,
            required int correctCount,
            required int totalQuestions,
            required String answersByQuestionIdJson,
            Value<String> questionTypesByQuestionIdJson = const Value.absent(),
            required DateTime completedAt,
            Value<String?> writtenSummary = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuizResultRecordsCompanion.insert(
            id: id,
            sessionId: sessionId,
            passageId: passageId,
            correctCount: correctCount,
            totalQuestions: totalQuestions,
            answersByQuestionIdJson: answersByQuestionIdJson,
            questionTypesByQuestionIdJson: questionTypesByQuestionIdJson,
            completedAt: completedAt,
            writtenSummary: writtenSummary,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuizResultRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuizResultRecordsTable,
    QuizResultRecord,
    $$QuizResultRecordsTableFilterComposer,
    $$QuizResultRecordsTableOrderingComposer,
    $$QuizResultRecordsTableAnnotationComposer,
    $$QuizResultRecordsTableCreateCompanionBuilder,
    $$QuizResultRecordsTableUpdateCompanionBuilder,
    (
      QuizResultRecord,
      BaseReferences<_$AppDatabase, $QuizResultRecordsTable, QuizResultRecord>
    ),
    QuizResultRecord,
    PrefetchHooks Function()>;
typedef $$DelayedRecallAttemptRecordsTableCreateCompanionBuilder
    = DelayedRecallAttemptRecordsCompanion Function({
  required String id,
  required String passageId,
  Value<String?> immediateSessionId,
  Value<String?> immediateQuizResultId,
  required DateTime recallCompletedAt,
  Value<DateTime?> immediateAttemptCompletedAt,
  Value<DateTime?> dueAt,
  required double score,
  Value<int> rowid,
});
typedef $$DelayedRecallAttemptRecordsTableUpdateCompanionBuilder
    = DelayedRecallAttemptRecordsCompanion Function({
  Value<String> id,
  Value<String> passageId,
  Value<String?> immediateSessionId,
  Value<String?> immediateQuizResultId,
  Value<DateTime> recallCompletedAt,
  Value<DateTime?> immediateAttemptCompletedAt,
  Value<DateTime?> dueAt,
  Value<double> score,
  Value<int> rowid,
});

class $$DelayedRecallAttemptRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DelayedRecallAttemptRecordsTable> {
  $$DelayedRecallAttemptRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passageId => $composableBuilder(
      column: $table.passageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get immediateSessionId => $composableBuilder(
      column: $table.immediateSessionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get immediateQuizResultId => $composableBuilder(
      column: $table.immediateQuizResultId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recallCompletedAt => $composableBuilder(
      column: $table.recallCompletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get immediateAttemptCompletedAt => $composableBuilder(
      column: $table.immediateAttemptCompletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));
}

class $$DelayedRecallAttemptRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DelayedRecallAttemptRecordsTable> {
  $$DelayedRecallAttemptRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passageId => $composableBuilder(
      column: $table.passageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get immediateSessionId => $composableBuilder(
      column: $table.immediateSessionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get immediateQuizResultId => $composableBuilder(
      column: $table.immediateQuizResultId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recallCompletedAt => $composableBuilder(
      column: $table.recallCompletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get immediateAttemptCompletedAt =>
      $composableBuilder(
          column: $table.immediateAttemptCompletedAt,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));
}

class $$DelayedRecallAttemptRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DelayedRecallAttemptRecordsTable> {
  $$DelayedRecallAttemptRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get passageId =>
      $composableBuilder(column: $table.passageId, builder: (column) => column);

  GeneratedColumn<String> get immediateSessionId => $composableBuilder(
      column: $table.immediateSessionId, builder: (column) => column);

  GeneratedColumn<String> get immediateQuizResultId => $composableBuilder(
      column: $table.immediateQuizResultId, builder: (column) => column);

  GeneratedColumn<DateTime> get recallCompletedAt => $composableBuilder(
      column: $table.recallCompletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get immediateAttemptCompletedAt =>
      $composableBuilder(
          column: $table.immediateAttemptCompletedAt,
          builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);
}

class $$DelayedRecallAttemptRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DelayedRecallAttemptRecordsTable,
    DelayedRecallAttemptRecord,
    $$DelayedRecallAttemptRecordsTableFilterComposer,
    $$DelayedRecallAttemptRecordsTableOrderingComposer,
    $$DelayedRecallAttemptRecordsTableAnnotationComposer,
    $$DelayedRecallAttemptRecordsTableCreateCompanionBuilder,
    $$DelayedRecallAttemptRecordsTableUpdateCompanionBuilder,
    (
      DelayedRecallAttemptRecord,
      BaseReferences<_$AppDatabase, $DelayedRecallAttemptRecordsTable,
          DelayedRecallAttemptRecord>
    ),
    DelayedRecallAttemptRecord,
    PrefetchHooks Function()> {
  $$DelayedRecallAttemptRecordsTableTableManager(
      _$AppDatabase db, $DelayedRecallAttemptRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DelayedRecallAttemptRecordsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DelayedRecallAttemptRecordsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DelayedRecallAttemptRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> passageId = const Value.absent(),
            Value<String?> immediateSessionId = const Value.absent(),
            Value<String?> immediateQuizResultId = const Value.absent(),
            Value<DateTime> recallCompletedAt = const Value.absent(),
            Value<DateTime?> immediateAttemptCompletedAt = const Value.absent(),
            Value<DateTime?> dueAt = const Value.absent(),
            Value<double> score = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DelayedRecallAttemptRecordsCompanion(
            id: id,
            passageId: passageId,
            immediateSessionId: immediateSessionId,
            immediateQuizResultId: immediateQuizResultId,
            recallCompletedAt: recallCompletedAt,
            immediateAttemptCompletedAt: immediateAttemptCompletedAt,
            dueAt: dueAt,
            score: score,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String passageId,
            Value<String?> immediateSessionId = const Value.absent(),
            Value<String?> immediateQuizResultId = const Value.absent(),
            required DateTime recallCompletedAt,
            Value<DateTime?> immediateAttemptCompletedAt = const Value.absent(),
            Value<DateTime?> dueAt = const Value.absent(),
            required double score,
            Value<int> rowid = const Value.absent(),
          }) =>
              DelayedRecallAttemptRecordsCompanion.insert(
            id: id,
            passageId: passageId,
            immediateSessionId: immediateSessionId,
            immediateQuizResultId: immediateQuizResultId,
            recallCompletedAt: recallCompletedAt,
            immediateAttemptCompletedAt: immediateAttemptCompletedAt,
            dueAt: dueAt,
            score: score,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DelayedRecallAttemptRecordsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DelayedRecallAttemptRecordsTable,
        DelayedRecallAttemptRecord,
        $$DelayedRecallAttemptRecordsTableFilterComposer,
        $$DelayedRecallAttemptRecordsTableOrderingComposer,
        $$DelayedRecallAttemptRecordsTableAnnotationComposer,
        $$DelayedRecallAttemptRecordsTableCreateCompanionBuilder,
        $$DelayedRecallAttemptRecordsTableUpdateCompanionBuilder,
        (
          DelayedRecallAttemptRecord,
          BaseReferences<_$AppDatabase, $DelayedRecallAttemptRecordsTable,
              DelayedRecallAttemptRecord>
        ),
        DelayedRecallAttemptRecord,
        PrefetchHooks Function()>;
typedef $$ProgressSnapshotRecordsTableCreateCompanionBuilder
    = ProgressSnapshotRecordsCompanion Function({
  required String id,
  required DateTime createdAt,
  required double latestWpm,
  required double latestComprehension,
  required double effectiveReadingScore,
  required double readinessPercent,
  required int level,
  required int streakDays,
  Value<int> rowid,
});
typedef $$ProgressSnapshotRecordsTableUpdateCompanionBuilder
    = ProgressSnapshotRecordsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<double> latestWpm,
  Value<double> latestComprehension,
  Value<double> effectiveReadingScore,
  Value<double> readinessPercent,
  Value<int> level,
  Value<int> streakDays,
  Value<int> rowid,
});

class $$ProgressSnapshotRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotRecordsTable> {
  $$ProgressSnapshotRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latestWpm => $composableBuilder(
      column: $table.latestWpm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latestComprehension => $composableBuilder(
      column: $table.latestComprehension,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get effectiveReadingScore => $composableBuilder(
      column: $table.effectiveReadingScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get readinessPercent => $composableBuilder(
      column: $table.readinessPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnFilters(column));
}

class $$ProgressSnapshotRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotRecordsTable> {
  $$ProgressSnapshotRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latestWpm => $composableBuilder(
      column: $table.latestWpm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latestComprehension => $composableBuilder(
      column: $table.latestComprehension,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get effectiveReadingScore => $composableBuilder(
      column: $table.effectiveReadingScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get readinessPercent => $composableBuilder(
      column: $table.readinessPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnOrderings(column));
}

class $$ProgressSnapshotRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotRecordsTable> {
  $$ProgressSnapshotRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get latestWpm =>
      $composableBuilder(column: $table.latestWpm, builder: (column) => column);

  GeneratedColumn<double> get latestComprehension => $composableBuilder(
      column: $table.latestComprehension, builder: (column) => column);

  GeneratedColumn<double> get effectiveReadingScore => $composableBuilder(
      column: $table.effectiveReadingScore, builder: (column) => column);

  GeneratedColumn<double> get readinessPercent => $composableBuilder(
      column: $table.readinessPercent, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => column);
}

class $$ProgressSnapshotRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressSnapshotRecordsTable,
    ProgressSnapshotRecord,
    $$ProgressSnapshotRecordsTableFilterComposer,
    $$ProgressSnapshotRecordsTableOrderingComposer,
    $$ProgressSnapshotRecordsTableAnnotationComposer,
    $$ProgressSnapshotRecordsTableCreateCompanionBuilder,
    $$ProgressSnapshotRecordsTableUpdateCompanionBuilder,
    (
      ProgressSnapshotRecord,
      BaseReferences<_$AppDatabase, $ProgressSnapshotRecordsTable,
          ProgressSnapshotRecord>
    ),
    ProgressSnapshotRecord,
    PrefetchHooks Function()> {
  $$ProgressSnapshotRecordsTableTableManager(
      _$AppDatabase db, $ProgressSnapshotRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressSnapshotRecordsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressSnapshotRecordsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressSnapshotRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<double> latestWpm = const Value.absent(),
            Value<double> latestComprehension = const Value.absent(),
            Value<double> effectiveReadingScore = const Value.absent(),
            Value<double> readinessPercent = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressSnapshotRecordsCompanion(
            id: id,
            createdAt: createdAt,
            latestWpm: latestWpm,
            latestComprehension: latestComprehension,
            effectiveReadingScore: effectiveReadingScore,
            readinessPercent: readinessPercent,
            level: level,
            streakDays: streakDays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime createdAt,
            required double latestWpm,
            required double latestComprehension,
            required double effectiveReadingScore,
            required double readinessPercent,
            required int level,
            required int streakDays,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressSnapshotRecordsCompanion.insert(
            id: id,
            createdAt: createdAt,
            latestWpm: latestWpm,
            latestComprehension: latestComprehension,
            effectiveReadingScore: effectiveReadingScore,
            readinessPercent: readinessPercent,
            level: level,
            streakDays: streakDays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgressSnapshotRecordsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProgressSnapshotRecordsTable,
        ProgressSnapshotRecord,
        $$ProgressSnapshotRecordsTableFilterComposer,
        $$ProgressSnapshotRecordsTableOrderingComposer,
        $$ProgressSnapshotRecordsTableAnnotationComposer,
        $$ProgressSnapshotRecordsTableCreateCompanionBuilder,
        $$ProgressSnapshotRecordsTableUpdateCompanionBuilder,
        (
          ProgressSnapshotRecord,
          BaseReferences<_$AppDatabase, $ProgressSnapshotRecordsTable,
              ProgressSnapshotRecord>
        ),
        ProgressSnapshotRecord,
        PrefetchHooks Function()>;
typedef $$CertificationAttemptRecordsTableCreateCompanionBuilder
    = CertificationAttemptRecordsCompanion Function({
  required String id,
  required String sessionIdsJson,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  required bool isCertified,
  Value<int> rowid,
});
typedef $$CertificationAttemptRecordsTableUpdateCompanionBuilder
    = CertificationAttemptRecordsCompanion Function({
  Value<String> id,
  Value<String> sessionIdsJson,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<bool> isCertified,
  Value<int> rowid,
});

class $$CertificationAttemptRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CertificationAttemptRecordsTable> {
  $$CertificationAttemptRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionIdsJson => $composableBuilder(
      column: $table.sessionIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCertified => $composableBuilder(
      column: $table.isCertified, builder: (column) => ColumnFilters(column));
}

class $$CertificationAttemptRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CertificationAttemptRecordsTable> {
  $$CertificationAttemptRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionIdsJson => $composableBuilder(
      column: $table.sessionIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCertified => $composableBuilder(
      column: $table.isCertified, builder: (column) => ColumnOrderings(column));
}

class $$CertificationAttemptRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CertificationAttemptRecordsTable> {
  $$CertificationAttemptRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionIdsJson => $composableBuilder(
      column: $table.sessionIdsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<bool> get isCertified => $composableBuilder(
      column: $table.isCertified, builder: (column) => column);
}

class $$CertificationAttemptRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CertificationAttemptRecordsTable,
    CertificationAttemptRecord,
    $$CertificationAttemptRecordsTableFilterComposer,
    $$CertificationAttemptRecordsTableOrderingComposer,
    $$CertificationAttemptRecordsTableAnnotationComposer,
    $$CertificationAttemptRecordsTableCreateCompanionBuilder,
    $$CertificationAttemptRecordsTableUpdateCompanionBuilder,
    (
      CertificationAttemptRecord,
      BaseReferences<_$AppDatabase, $CertificationAttemptRecordsTable,
          CertificationAttemptRecord>
    ),
    CertificationAttemptRecord,
    PrefetchHooks Function()> {
  $$CertificationAttemptRecordsTableTableManager(
      _$AppDatabase db, $CertificationAttemptRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CertificationAttemptRecordsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CertificationAttemptRecordsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CertificationAttemptRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionIdsJson = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> isCertified = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CertificationAttemptRecordsCompanion(
            id: id,
            sessionIdsJson: sessionIdsJson,
            startedAt: startedAt,
            completedAt: completedAt,
            isCertified: isCertified,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionIdsJson,
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required bool isCertified,
            Value<int> rowid = const Value.absent(),
          }) =>
              CertificationAttemptRecordsCompanion.insert(
            id: id,
            sessionIdsJson: sessionIdsJson,
            startedAt: startedAt,
            completedAt: completedAt,
            isCertified: isCertified,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CertificationAttemptRecordsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CertificationAttemptRecordsTable,
        CertificationAttemptRecord,
        $$CertificationAttemptRecordsTableFilterComposer,
        $$CertificationAttemptRecordsTableOrderingComposer,
        $$CertificationAttemptRecordsTableAnnotationComposer,
        $$CertificationAttemptRecordsTableCreateCompanionBuilder,
        $$CertificationAttemptRecordsTableUpdateCompanionBuilder,
        (
          CertificationAttemptRecord,
          BaseReferences<_$AppDatabase, $CertificationAttemptRecordsTable,
              CertificationAttemptRecord>
        ),
        CertificationAttemptRecord,
        PrefetchHooks Function()>;
typedef $$MasteryAttemptRecordsTableCreateCompanionBuilder
    = MasteryAttemptRecordsCompanion Function({
  required String id,
  required String sessionIdsJson,
  required String delayedRecallQuizResultIdsJson,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  required bool isMastered,
  Value<int> rowid,
});
typedef $$MasteryAttemptRecordsTableUpdateCompanionBuilder
    = MasteryAttemptRecordsCompanion Function({
  Value<String> id,
  Value<String> sessionIdsJson,
  Value<String> delayedRecallQuizResultIdsJson,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<bool> isMastered,
  Value<int> rowid,
});

class $$MasteryAttemptRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MasteryAttemptRecordsTable> {
  $$MasteryAttemptRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionIdsJson => $composableBuilder(
      column: $table.sessionIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get delayedRecallQuizResultIdsJson =>
      $composableBuilder(
          column: $table.delayedRecallQuizResultIdsJson,
          builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => ColumnFilters(column));
}

class $$MasteryAttemptRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MasteryAttemptRecordsTable> {
  $$MasteryAttemptRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionIdsJson => $composableBuilder(
      column: $table.sessionIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get delayedRecallQuizResultIdsJson =>
      $composableBuilder(
          column: $table.delayedRecallQuizResultIdsJson,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => ColumnOrderings(column));
}

class $$MasteryAttemptRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MasteryAttemptRecordsTable> {
  $$MasteryAttemptRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionIdsJson => $composableBuilder(
      column: $table.sessionIdsJson, builder: (column) => column);

  GeneratedColumn<String> get delayedRecallQuizResultIdsJson =>
      $composableBuilder(
          column: $table.delayedRecallQuizResultIdsJson,
          builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => column);
}

class $$MasteryAttemptRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MasteryAttemptRecordsTable,
    MasteryAttemptRecord,
    $$MasteryAttemptRecordsTableFilterComposer,
    $$MasteryAttemptRecordsTableOrderingComposer,
    $$MasteryAttemptRecordsTableAnnotationComposer,
    $$MasteryAttemptRecordsTableCreateCompanionBuilder,
    $$MasteryAttemptRecordsTableUpdateCompanionBuilder,
    (
      MasteryAttemptRecord,
      BaseReferences<_$AppDatabase, $MasteryAttemptRecordsTable,
          MasteryAttemptRecord>
    ),
    MasteryAttemptRecord,
    PrefetchHooks Function()> {
  $$MasteryAttemptRecordsTableTableManager(
      _$AppDatabase db, $MasteryAttemptRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasteryAttemptRecordsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MasteryAttemptRecordsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasteryAttemptRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionIdsJson = const Value.absent(),
            Value<String> delayedRecallQuizResultIdsJson = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> isMastered = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MasteryAttemptRecordsCompanion(
            id: id,
            sessionIdsJson: sessionIdsJson,
            delayedRecallQuizResultIdsJson: delayedRecallQuizResultIdsJson,
            startedAt: startedAt,
            completedAt: completedAt,
            isMastered: isMastered,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionIdsJson,
            required String delayedRecallQuizResultIdsJson,
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required bool isMastered,
            Value<int> rowid = const Value.absent(),
          }) =>
              MasteryAttemptRecordsCompanion.insert(
            id: id,
            sessionIdsJson: sessionIdsJson,
            delayedRecallQuizResultIdsJson: delayedRecallQuizResultIdsJson,
            startedAt: startedAt,
            completedAt: completedAt,
            isMastered: isMastered,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MasteryAttemptRecordsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MasteryAttemptRecordsTable,
        MasteryAttemptRecord,
        $$MasteryAttemptRecordsTableFilterComposer,
        $$MasteryAttemptRecordsTableOrderingComposer,
        $$MasteryAttemptRecordsTableAnnotationComposer,
        $$MasteryAttemptRecordsTableCreateCompanionBuilder,
        $$MasteryAttemptRecordsTableUpdateCompanionBuilder,
        (
          MasteryAttemptRecord,
          BaseReferences<_$AppDatabase, $MasteryAttemptRecordsTable,
              MasteryAttemptRecord>
        ),
        MasteryAttemptRecord,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$PassageRecordsTableTableManager get passageRecords =>
      $$PassageRecordsTableTableManager(_db, _db.passageRecords);
  $$ReadingSessionRecordsTableTableManager get readingSessionRecords =>
      $$ReadingSessionRecordsTableTableManager(_db, _db.readingSessionRecords);
  $$QuizResultRecordsTableTableManager get quizResultRecords =>
      $$QuizResultRecordsTableTableManager(_db, _db.quizResultRecords);
  $$DelayedRecallAttemptRecordsTableTableManager
      get delayedRecallAttemptRecords =>
          $$DelayedRecallAttemptRecordsTableTableManager(
              _db, _db.delayedRecallAttemptRecords);
  $$ProgressSnapshotRecordsTableTableManager get progressSnapshotRecords =>
      $$ProgressSnapshotRecordsTableTableManager(
          _db, _db.progressSnapshotRecords);
  $$CertificationAttemptRecordsTableTableManager
      get certificationAttemptRecords =>
          $$CertificationAttemptRecordsTableTableManager(
              _db, _db.certificationAttemptRecords);
  $$MasteryAttemptRecordsTableTableManager get masteryAttemptRecords =>
      $$MasteryAttemptRecordsTableTableManager(_db, _db.masteryAttemptRecords);
}
