// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServerProfilesTable extends ServerProfiles
    with TableInfo<$ServerProfilesTable, ServerProfileRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _defaultDirectoryMeta = const VerificationMeta(
    'defaultDirectory',
  );
  @override
  late final GeneratedColumn<String> defaultDirectory = GeneratedColumn<String>(
    'default_directory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _terminalThemeMeta = const VerificationMeta(
    'terminalTheme',
  );
  @override
  late final GeneratedColumn<String> terminalTheme = GeneratedColumn<String>(
    'terminal_theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authMethodMeta = const VerificationMeta(
    'authMethod',
  );
  @override
  late final GeneratedColumn<String> authMethod = GeneratedColumn<String>(
    'auth_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _credentialRefIdMeta = const VerificationMeta(
    'credentialRefId',
  );
  @override
  late final GeneratedColumn<String> credentialRefId = GeneratedColumn<String>(
    'credential_ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkModeMeta = const VerificationMeta(
    'networkMode',
  );
  @override
  late final GeneratedColumn<String> networkMode = GeneratedColumn<String>(
    'network_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _managedBrowserUrlMeta = const VerificationMeta(
    'managedBrowserUrl',
  );
  @override
  late final GeneratedColumn<String> managedBrowserUrl =
      GeneratedColumn<String>(
        'managed_browser_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _managedTargetHintMeta = const VerificationMeta(
    'managedTargetHint',
  );
  @override
  late final GeneratedColumn<String> managedTargetHint =
      GeneratedColumn<String>(
        'managed_target_hint',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preflightRequirementsJsonMeta =
      const VerificationMeta('preflightRequirementsJson');
  @override
  late final GeneratedColumn<String> preflightRequirementsJson =
      GeneratedColumn<String>(
        'preflight_requirements_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    host,
    port,
    username,
    tagsJson,
    defaultDirectory,
    terminalTheme,
    authMethod,
    credentialRefId,
    networkMode,
    managedBrowserUrl,
    managedTargetHint,
    preflightRequirementsJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServerProfileRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('default_directory')) {
      context.handle(
        _defaultDirectoryMeta,
        defaultDirectory.isAcceptableOrUnknown(
          data['default_directory']!,
          _defaultDirectoryMeta,
        ),
      );
    }
    if (data.containsKey('terminal_theme')) {
      context.handle(
        _terminalThemeMeta,
        terminalTheme.isAcceptableOrUnknown(
          data['terminal_theme']!,
          _terminalThemeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_terminalThemeMeta);
    }
    if (data.containsKey('auth_method')) {
      context.handle(
        _authMethodMeta,
        authMethod.isAcceptableOrUnknown(data['auth_method']!, _authMethodMeta),
      );
    } else if (isInserting) {
      context.missing(_authMethodMeta);
    }
    if (data.containsKey('credential_ref_id')) {
      context.handle(
        _credentialRefIdMeta,
        credentialRefId.isAcceptableOrUnknown(
          data['credential_ref_id']!,
          _credentialRefIdMeta,
        ),
      );
    }
    if (data.containsKey('network_mode')) {
      context.handle(
        _networkModeMeta,
        networkMode.isAcceptableOrUnknown(
          data['network_mode']!,
          _networkModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_networkModeMeta);
    }
    if (data.containsKey('managed_browser_url')) {
      context.handle(
        _managedBrowserUrlMeta,
        managedBrowserUrl.isAcceptableOrUnknown(
          data['managed_browser_url']!,
          _managedBrowserUrlMeta,
        ),
      );
    }
    if (data.containsKey('managed_target_hint')) {
      context.handle(
        _managedTargetHintMeta,
        managedTargetHint.isAcceptableOrUnknown(
          data['managed_target_hint']!,
          _managedTargetHintMeta,
        ),
      );
    }
    if (data.containsKey('preflight_requirements_json')) {
      context.handle(
        _preflightRequirementsJsonMeta,
        preflightRequirementsJson.isAcceptableOrUnknown(
          data['preflight_requirements_json']!,
          _preflightRequirementsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerProfileRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerProfileRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      defaultDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_directory'],
      ),
      terminalTheme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terminal_theme'],
      )!,
      authMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_method'],
      )!,
      credentialRefId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credential_ref_id'],
      ),
      networkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_mode'],
      )!,
      managedBrowserUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}managed_browser_url'],
      ),
      managedTargetHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}managed_target_hint'],
      ),
      preflightRequirementsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preflight_requirements_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ServerProfilesTable createAlias(String alias) {
    return $ServerProfilesTable(attachedDatabase, alias);
  }
}

class ServerProfileRecord extends DataClass
    implements Insertable<ServerProfileRecord> {
  final String id;
  final String label;
  final String host;
  final int port;
  final String username;
  final String tagsJson;
  final String? defaultDirectory;
  final String terminalTheme;
  final String authMethod;
  final String? credentialRefId;
  final String networkMode;
  final String? managedBrowserUrl;
  final String? managedTargetHint;
  final String preflightRequirementsJson;
  final int createdAt;
  final int? updatedAt;
  const ServerProfileRecord({
    required this.id,
    required this.label,
    required this.host,
    required this.port,
    required this.username,
    required this.tagsJson,
    this.defaultDirectory,
    required this.terminalTheme,
    required this.authMethod,
    this.credentialRefId,
    required this.networkMode,
    this.managedBrowserUrl,
    this.managedTargetHint,
    required this.preflightRequirementsJson,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || defaultDirectory != null) {
      map['default_directory'] = Variable<String>(defaultDirectory);
    }
    map['terminal_theme'] = Variable<String>(terminalTheme);
    map['auth_method'] = Variable<String>(authMethod);
    if (!nullToAbsent || credentialRefId != null) {
      map['credential_ref_id'] = Variable<String>(credentialRefId);
    }
    map['network_mode'] = Variable<String>(networkMode);
    if (!nullToAbsent || managedBrowserUrl != null) {
      map['managed_browser_url'] = Variable<String>(managedBrowserUrl);
    }
    if (!nullToAbsent || managedTargetHint != null) {
      map['managed_target_hint'] = Variable<String>(managedTargetHint);
    }
    map['preflight_requirements_json'] = Variable<String>(
      preflightRequirementsJson,
    );
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  ServerProfilesCompanion toCompanion(bool nullToAbsent) {
    return ServerProfilesCompanion(
      id: Value(id),
      label: Value(label),
      host: Value(host),
      port: Value(port),
      username: Value(username),
      tagsJson: Value(tagsJson),
      defaultDirectory: defaultDirectory == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultDirectory),
      terminalTheme: Value(terminalTheme),
      authMethod: Value(authMethod),
      credentialRefId: credentialRefId == null && nullToAbsent
          ? const Value.absent()
          : Value(credentialRefId),
      networkMode: Value(networkMode),
      managedBrowserUrl: managedBrowserUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(managedBrowserUrl),
      managedTargetHint: managedTargetHint == null && nullToAbsent
          ? const Value.absent()
          : Value(managedTargetHint),
      preflightRequirementsJson: Value(preflightRequirementsJson),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ServerProfileRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerProfileRecord(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      defaultDirectory: serializer.fromJson<String?>(json['defaultDirectory']),
      terminalTheme: serializer.fromJson<String>(json['terminalTheme']),
      authMethod: serializer.fromJson<String>(json['authMethod']),
      credentialRefId: serializer.fromJson<String?>(json['credentialRefId']),
      networkMode: serializer.fromJson<String>(json['networkMode']),
      managedBrowserUrl: serializer.fromJson<String?>(
        json['managedBrowserUrl'],
      ),
      managedTargetHint: serializer.fromJson<String?>(
        json['managedTargetHint'],
      ),
      preflightRequirementsJson: serializer.fromJson<String>(
        json['preflightRequirementsJson'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'defaultDirectory': serializer.toJson<String?>(defaultDirectory),
      'terminalTheme': serializer.toJson<String>(terminalTheme),
      'authMethod': serializer.toJson<String>(authMethod),
      'credentialRefId': serializer.toJson<String?>(credentialRefId),
      'networkMode': serializer.toJson<String>(networkMode),
      'managedBrowserUrl': serializer.toJson<String?>(managedBrowserUrl),
      'managedTargetHint': serializer.toJson<String?>(managedTargetHint),
      'preflightRequirementsJson': serializer.toJson<String>(
        preflightRequirementsJson,
      ),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  ServerProfileRecord copyWith({
    String? id,
    String? label,
    String? host,
    int? port,
    String? username,
    String? tagsJson,
    Value<String?> defaultDirectory = const Value.absent(),
    String? terminalTheme,
    String? authMethod,
    Value<String?> credentialRefId = const Value.absent(),
    String? networkMode,
    Value<String?> managedBrowserUrl = const Value.absent(),
    Value<String?> managedTargetHint = const Value.absent(),
    String? preflightRequirementsJson,
    int? createdAt,
    Value<int?> updatedAt = const Value.absent(),
  }) => ServerProfileRecord(
    id: id ?? this.id,
    label: label ?? this.label,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username ?? this.username,
    tagsJson: tagsJson ?? this.tagsJson,
    defaultDirectory: defaultDirectory.present
        ? defaultDirectory.value
        : this.defaultDirectory,
    terminalTheme: terminalTheme ?? this.terminalTheme,
    authMethod: authMethod ?? this.authMethod,
    credentialRefId: credentialRefId.present
        ? credentialRefId.value
        : this.credentialRefId,
    networkMode: networkMode ?? this.networkMode,
    managedBrowserUrl: managedBrowserUrl.present
        ? managedBrowserUrl.value
        : this.managedBrowserUrl,
    managedTargetHint: managedTargetHint.present
        ? managedTargetHint.value
        : this.managedTargetHint,
    preflightRequirementsJson:
        preflightRequirementsJson ?? this.preflightRequirementsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ServerProfileRecord copyWithCompanion(ServerProfilesCompanion data) {
    return ServerProfileRecord(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      defaultDirectory: data.defaultDirectory.present
          ? data.defaultDirectory.value
          : this.defaultDirectory,
      terminalTheme: data.terminalTheme.present
          ? data.terminalTheme.value
          : this.terminalTheme,
      authMethod: data.authMethod.present
          ? data.authMethod.value
          : this.authMethod,
      credentialRefId: data.credentialRefId.present
          ? data.credentialRefId.value
          : this.credentialRefId,
      networkMode: data.networkMode.present
          ? data.networkMode.value
          : this.networkMode,
      managedBrowserUrl: data.managedBrowserUrl.present
          ? data.managedBrowserUrl.value
          : this.managedBrowserUrl,
      managedTargetHint: data.managedTargetHint.present
          ? data.managedTargetHint.value
          : this.managedTargetHint,
      preflightRequirementsJson: data.preflightRequirementsJson.present
          ? data.preflightRequirementsJson.value
          : this.preflightRequirementsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerProfileRecord(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('defaultDirectory: $defaultDirectory, ')
          ..write('terminalTheme: $terminalTheme, ')
          ..write('authMethod: $authMethod, ')
          ..write('credentialRefId: $credentialRefId, ')
          ..write('networkMode: $networkMode, ')
          ..write('managedBrowserUrl: $managedBrowserUrl, ')
          ..write('managedTargetHint: $managedTargetHint, ')
          ..write('preflightRequirementsJson: $preflightRequirementsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    host,
    port,
    username,
    tagsJson,
    defaultDirectory,
    terminalTheme,
    authMethod,
    credentialRefId,
    networkMode,
    managedBrowserUrl,
    managedTargetHint,
    preflightRequirementsJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerProfileRecord &&
          other.id == this.id &&
          other.label == this.label &&
          other.host == this.host &&
          other.port == this.port &&
          other.username == this.username &&
          other.tagsJson == this.tagsJson &&
          other.defaultDirectory == this.defaultDirectory &&
          other.terminalTheme == this.terminalTheme &&
          other.authMethod == this.authMethod &&
          other.credentialRefId == this.credentialRefId &&
          other.networkMode == this.networkMode &&
          other.managedBrowserUrl == this.managedBrowserUrl &&
          other.managedTargetHint == this.managedTargetHint &&
          other.preflightRequirementsJson == this.preflightRequirementsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServerProfilesCompanion extends UpdateCompanion<ServerProfileRecord> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> host;
  final Value<int> port;
  final Value<String> username;
  final Value<String> tagsJson;
  final Value<String?> defaultDirectory;
  final Value<String> terminalTheme;
  final Value<String> authMethod;
  final Value<String?> credentialRefId;
  final Value<String> networkMode;
  final Value<String?> managedBrowserUrl;
  final Value<String?> managedTargetHint;
  final Value<String> preflightRequirementsJson;
  final Value<int> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const ServerProfilesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.defaultDirectory = const Value.absent(),
    this.terminalTheme = const Value.absent(),
    this.authMethod = const Value.absent(),
    this.credentialRefId = const Value.absent(),
    this.networkMode = const Value.absent(),
    this.managedBrowserUrl = const Value.absent(),
    this.managedTargetHint = const Value.absent(),
    this.preflightRequirementsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServerProfilesCompanion.insert({
    required String id,
    required String label,
    required String host,
    required int port,
    required String username,
    this.tagsJson = const Value.absent(),
    this.defaultDirectory = const Value.absent(),
    required String terminalTheme,
    required String authMethod,
    this.credentialRefId = const Value.absent(),
    required String networkMode,
    this.managedBrowserUrl = const Value.absent(),
    this.managedTargetHint = const Value.absent(),
    this.preflightRequirementsJson = const Value.absent(),
    required int createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       host = Value(host),
       port = Value(port),
       username = Value(username),
       terminalTheme = Value(terminalTheme),
       authMethod = Value(authMethod),
       networkMode = Value(networkMode),
       createdAt = Value(createdAt);
  static Insertable<ServerProfileRecord> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? tagsJson,
    Expression<String>? defaultDirectory,
    Expression<String>? terminalTheme,
    Expression<String>? authMethod,
    Expression<String>? credentialRefId,
    Expression<String>? networkMode,
    Expression<String>? managedBrowserUrl,
    Expression<String>? managedTargetHint,
    Expression<String>? preflightRequirementsJson,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (defaultDirectory != null) 'default_directory': defaultDirectory,
      if (terminalTheme != null) 'terminal_theme': terminalTheme,
      if (authMethod != null) 'auth_method': authMethod,
      if (credentialRefId != null) 'credential_ref_id': credentialRefId,
      if (networkMode != null) 'network_mode': networkMode,
      if (managedBrowserUrl != null) 'managed_browser_url': managedBrowserUrl,
      if (managedTargetHint != null) 'managed_target_hint': managedTargetHint,
      if (preflightRequirementsJson != null)
        'preflight_requirements_json': preflightRequirementsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServerProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? host,
    Value<int>? port,
    Value<String>? username,
    Value<String>? tagsJson,
    Value<String?>? defaultDirectory,
    Value<String>? terminalTheme,
    Value<String>? authMethod,
    Value<String?>? credentialRefId,
    Value<String>? networkMode,
    Value<String?>? managedBrowserUrl,
    Value<String?>? managedTargetHint,
    Value<String>? preflightRequirementsJson,
    Value<int>? createdAt,
    Value<int?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ServerProfilesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      tagsJson: tagsJson ?? this.tagsJson,
      defaultDirectory: defaultDirectory ?? this.defaultDirectory,
      terminalTheme: terminalTheme ?? this.terminalTheme,
      authMethod: authMethod ?? this.authMethod,
      credentialRefId: credentialRefId ?? this.credentialRefId,
      networkMode: networkMode ?? this.networkMode,
      managedBrowserUrl: managedBrowserUrl ?? this.managedBrowserUrl,
      managedTargetHint: managedTargetHint ?? this.managedTargetHint,
      preflightRequirementsJson:
          preflightRequirementsJson ?? this.preflightRequirementsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (defaultDirectory.present) {
      map['default_directory'] = Variable<String>(defaultDirectory.value);
    }
    if (terminalTheme.present) {
      map['terminal_theme'] = Variable<String>(terminalTheme.value);
    }
    if (authMethod.present) {
      map['auth_method'] = Variable<String>(authMethod.value);
    }
    if (credentialRefId.present) {
      map['credential_ref_id'] = Variable<String>(credentialRefId.value);
    }
    if (networkMode.present) {
      map['network_mode'] = Variable<String>(networkMode.value);
    }
    if (managedBrowserUrl.present) {
      map['managed_browser_url'] = Variable<String>(managedBrowserUrl.value);
    }
    if (managedTargetHint.present) {
      map['managed_target_hint'] = Variable<String>(managedTargetHint.value);
    }
    if (preflightRequirementsJson.present) {
      map['preflight_requirements_json'] = Variable<String>(
        preflightRequirementsJson.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('defaultDirectory: $defaultDirectory, ')
          ..write('terminalTheme: $terminalTheme, ')
          ..write('authMethod: $authMethod, ')
          ..write('credentialRefId: $credentialRefId, ')
          ..write('networkMode: $networkMode, ')
          ..write('managedBrowserUrl: $managedBrowserUrl, ')
          ..write('managedTargetHint: $managedTargetHint, ')
          ..write('preflightRequirementsJson: $preflightRequirementsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JumpHopsTable extends JumpHops
    with TableInfo<$JumpHopsTable, JumpHopRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JumpHopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hopOrderMeta = const VerificationMeta(
    'hopOrder',
  );
  @override
  late final GeneratedColumn<int> hopOrder = GeneratedColumn<int>(
    'hop_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hopProfileIdMeta = const VerificationMeta(
    'hopProfileId',
  );
  @override
  late final GeneratedColumn<String> hopProfileId = GeneratedColumn<String>(
    'hop_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, profileId, hopOrder, hopProfileId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jump_hops';
  @override
  VerificationContext validateIntegrity(
    Insertable<JumpHopRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('hop_order')) {
      context.handle(
        _hopOrderMeta,
        hopOrder.isAcceptableOrUnknown(data['hop_order']!, _hopOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_hopOrderMeta);
    }
    if (data.containsKey('hop_profile_id')) {
      context.handle(
        _hopProfileIdMeta,
        hopProfileId.isAcceptableOrUnknown(
          data['hop_profile_id']!,
          _hopProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hopProfileIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JumpHopRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JumpHopRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      hopOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hop_order'],
      )!,
      hopProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hop_profile_id'],
      )!,
    );
  }

  @override
  $JumpHopsTable createAlias(String alias) {
    return $JumpHopsTable(attachedDatabase, alias);
  }
}

class JumpHopRecord extends DataClass implements Insertable<JumpHopRecord> {
  final String id;
  final String profileId;
  final int hopOrder;
  final String hopProfileId;
  const JumpHopRecord({
    required this.id,
    required this.profileId,
    required this.hopOrder,
    required this.hopProfileId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['hop_order'] = Variable<int>(hopOrder);
    map['hop_profile_id'] = Variable<String>(hopProfileId);
    return map;
  }

  JumpHopsCompanion toCompanion(bool nullToAbsent) {
    return JumpHopsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      hopOrder: Value(hopOrder),
      hopProfileId: Value(hopProfileId),
    );
  }

  factory JumpHopRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JumpHopRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      hopOrder: serializer.fromJson<int>(json['hopOrder']),
      hopProfileId: serializer.fromJson<String>(json['hopProfileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'hopOrder': serializer.toJson<int>(hopOrder),
      'hopProfileId': serializer.toJson<String>(hopProfileId),
    };
  }

  JumpHopRecord copyWith({
    String? id,
    String? profileId,
    int? hopOrder,
    String? hopProfileId,
  }) => JumpHopRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    hopOrder: hopOrder ?? this.hopOrder,
    hopProfileId: hopProfileId ?? this.hopProfileId,
  );
  JumpHopRecord copyWithCompanion(JumpHopsCompanion data) {
    return JumpHopRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      hopOrder: data.hopOrder.present ? data.hopOrder.value : this.hopOrder,
      hopProfileId: data.hopProfileId.present
          ? data.hopProfileId.value
          : this.hopProfileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JumpHopRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('hopOrder: $hopOrder, ')
          ..write('hopProfileId: $hopProfileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, hopOrder, hopProfileId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JumpHopRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.hopOrder == this.hopOrder &&
          other.hopProfileId == this.hopProfileId);
}

class JumpHopsCompanion extends UpdateCompanion<JumpHopRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> hopOrder;
  final Value<String> hopProfileId;
  final Value<int> rowid;
  const JumpHopsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.hopOrder = const Value.absent(),
    this.hopProfileId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JumpHopsCompanion.insert({
    required String id,
    required String profileId,
    required int hopOrder,
    required String hopProfileId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       hopOrder = Value(hopOrder),
       hopProfileId = Value(hopProfileId);
  static Insertable<JumpHopRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? hopOrder,
    Expression<String>? hopProfileId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (hopOrder != null) 'hop_order': hopOrder,
      if (hopProfileId != null) 'hop_profile_id': hopProfileId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JumpHopsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? hopOrder,
    Value<String>? hopProfileId,
    Value<int>? rowid,
  }) {
    return JumpHopsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      hopOrder: hopOrder ?? this.hopOrder,
      hopProfileId: hopProfileId ?? this.hopProfileId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (hopOrder.present) {
      map['hop_order'] = Variable<int>(hopOrder.value);
    }
    if (hopProfileId.present) {
      map['hop_profile_id'] = Variable<String>(hopProfileId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JumpHopsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('hopOrder: $hopOrder, ')
          ..write('hopProfileId: $hopProfileId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CredentialRefsTable extends CredentialRefs
    with TableInfo<$CredentialRefsTable, CredentialRefRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CredentialRefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameHintMeta = const VerificationMeta(
    'usernameHint',
  );
  @override
  late final GeneratedColumn<String> usernameHint = GeneratedColumn<String>(
    'username_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresBiometricMeta = const VerificationMeta(
    'requiresBiometric',
  );
  @override
  late final GeneratedColumn<bool> requiresBiometric = GeneratedColumn<bool>(
    'requires_biometric',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_biometric" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _publicKeyFingerprintMeta =
      const VerificationMeta('publicKeyFingerprint');
  @override
  late final GeneratedColumn<String> publicKeyFingerprint =
      GeneratedColumn<String>(
        'public_key_fingerprint',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isEncryptedMeta = const VerificationMeta(
    'isEncrypted',
  );
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
    'is_encrypted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_encrypted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    kind,
    usernameHint,
    requiresBiometric,
    publicKeyFingerprint,
    isEncrypted,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credential_refs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CredentialRefRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('username_hint')) {
      context.handle(
        _usernameHintMeta,
        usernameHint.isAcceptableOrUnknown(
          data['username_hint']!,
          _usernameHintMeta,
        ),
      );
    }
    if (data.containsKey('requires_biometric')) {
      context.handle(
        _requiresBiometricMeta,
        requiresBiometric.isAcceptableOrUnknown(
          data['requires_biometric']!,
          _requiresBiometricMeta,
        ),
      );
    }
    if (data.containsKey('public_key_fingerprint')) {
      context.handle(
        _publicKeyFingerprintMeta,
        publicKeyFingerprint.isAcceptableOrUnknown(
          data['public_key_fingerprint']!,
          _publicKeyFingerprintMeta,
        ),
      );
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
        _isEncryptedMeta,
        isEncrypted.isAcceptableOrUnknown(
          data['is_encrypted']!,
          _isEncryptedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CredentialRefRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CredentialRefRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      usernameHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username_hint'],
      ),
      requiresBiometric: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_biometric'],
      )!,
      publicKeyFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_key_fingerprint'],
      ),
      isEncrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_encrypted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CredentialRefsTable createAlias(String alias) {
    return $CredentialRefsTable(attachedDatabase, alias);
  }
}

class CredentialRefRecord extends DataClass
    implements Insertable<CredentialRefRecord> {
  final String id;
  final String label;
  final String kind;
  final String? usernameHint;
  final bool requiresBiometric;
  final String? publicKeyFingerprint;
  final bool isEncrypted;
  final int createdAt;
  const CredentialRefRecord({
    required this.id,
    required this.label,
    required this.kind,
    this.usernameHint,
    required this.requiresBiometric,
    this.publicKeyFingerprint,
    required this.isEncrypted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || usernameHint != null) {
      map['username_hint'] = Variable<String>(usernameHint);
    }
    map['requires_biometric'] = Variable<bool>(requiresBiometric);
    if (!nullToAbsent || publicKeyFingerprint != null) {
      map['public_key_fingerprint'] = Variable<String>(publicKeyFingerprint);
    }
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CredentialRefsCompanion toCompanion(bool nullToAbsent) {
    return CredentialRefsCompanion(
      id: Value(id),
      label: Value(label),
      kind: Value(kind),
      usernameHint: usernameHint == null && nullToAbsent
          ? const Value.absent()
          : Value(usernameHint),
      requiresBiometric: Value(requiresBiometric),
      publicKeyFingerprint: publicKeyFingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(publicKeyFingerprint),
      isEncrypted: Value(isEncrypted),
      createdAt: Value(createdAt),
    );
  }

  factory CredentialRefRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CredentialRefRecord(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      kind: serializer.fromJson<String>(json['kind']),
      usernameHint: serializer.fromJson<String?>(json['usernameHint']),
      requiresBiometric: serializer.fromJson<bool>(json['requiresBiometric']),
      publicKeyFingerprint: serializer.fromJson<String?>(
        json['publicKeyFingerprint'],
      ),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(kind),
      'usernameHint': serializer.toJson<String?>(usernameHint),
      'requiresBiometric': serializer.toJson<bool>(requiresBiometric),
      'publicKeyFingerprint': serializer.toJson<String?>(publicKeyFingerprint),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  CredentialRefRecord copyWith({
    String? id,
    String? label,
    String? kind,
    Value<String?> usernameHint = const Value.absent(),
    bool? requiresBiometric,
    Value<String?> publicKeyFingerprint = const Value.absent(),
    bool? isEncrypted,
    int? createdAt,
  }) => CredentialRefRecord(
    id: id ?? this.id,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    usernameHint: usernameHint.present ? usernameHint.value : this.usernameHint,
    requiresBiometric: requiresBiometric ?? this.requiresBiometric,
    publicKeyFingerprint: publicKeyFingerprint.present
        ? publicKeyFingerprint.value
        : this.publicKeyFingerprint,
    isEncrypted: isEncrypted ?? this.isEncrypted,
    createdAt: createdAt ?? this.createdAt,
  );
  CredentialRefRecord copyWithCompanion(CredentialRefsCompanion data) {
    return CredentialRefRecord(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      usernameHint: data.usernameHint.present
          ? data.usernameHint.value
          : this.usernameHint,
      requiresBiometric: data.requiresBiometric.present
          ? data.requiresBiometric.value
          : this.requiresBiometric,
      publicKeyFingerprint: data.publicKeyFingerprint.present
          ? data.publicKeyFingerprint.value
          : this.publicKeyFingerprint,
      isEncrypted: data.isEncrypted.present
          ? data.isEncrypted.value
          : this.isEncrypted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CredentialRefRecord(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('usernameHint: $usernameHint, ')
          ..write('requiresBiometric: $requiresBiometric, ')
          ..write('publicKeyFingerprint: $publicKeyFingerprint, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    kind,
    usernameHint,
    requiresBiometric,
    publicKeyFingerprint,
    isEncrypted,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CredentialRefRecord &&
          other.id == this.id &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.usernameHint == this.usernameHint &&
          other.requiresBiometric == this.requiresBiometric &&
          other.publicKeyFingerprint == this.publicKeyFingerprint &&
          other.isEncrypted == this.isEncrypted &&
          other.createdAt == this.createdAt);
}

class CredentialRefsCompanion extends UpdateCompanion<CredentialRefRecord> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> kind;
  final Value<String?> usernameHint;
  final Value<bool> requiresBiometric;
  final Value<String?> publicKeyFingerprint;
  final Value<bool> isEncrypted;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CredentialRefsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.usernameHint = const Value.absent(),
    this.requiresBiometric = const Value.absent(),
    this.publicKeyFingerprint = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CredentialRefsCompanion.insert({
    required String id,
    required String label,
    required String kind,
    this.usernameHint = const Value.absent(),
    this.requiresBiometric = const Value.absent(),
    this.publicKeyFingerprint = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       kind = Value(kind),
       createdAt = Value(createdAt);
  static Insertable<CredentialRefRecord> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<String>? usernameHint,
    Expression<bool>? requiresBiometric,
    Expression<String>? publicKeyFingerprint,
    Expression<bool>? isEncrypted,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (usernameHint != null) 'username_hint': usernameHint,
      if (requiresBiometric != null) 'requires_biometric': requiresBiometric,
      if (publicKeyFingerprint != null)
        'public_key_fingerprint': publicKeyFingerprint,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CredentialRefsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? kind,
    Value<String?>? usernameHint,
    Value<bool>? requiresBiometric,
    Value<String?>? publicKeyFingerprint,
    Value<bool>? isEncrypted,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return CredentialRefsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      usernameHint: usernameHint ?? this.usernameHint,
      requiresBiometric: requiresBiometric ?? this.requiresBiometric,
      publicKeyFingerprint: publicKeyFingerprint ?? this.publicKeyFingerprint,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (usernameHint.present) {
      map['username_hint'] = Variable<String>(usernameHint.value);
    }
    if (requiresBiometric.present) {
      map['requires_biometric'] = Variable<bool>(requiresBiometric.value);
    }
    if (publicKeyFingerprint.present) {
      map['public_key_fingerprint'] = Variable<String>(
        publicKeyFingerprint.value,
      );
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CredentialRefsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('usernameHint: $usernameHint, ')
          ..write('requiresBiometric: $requiresBiometric, ')
          ..write('publicKeyFingerprint: $publicKeyFingerprint, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PortForwardProfilesTable extends PortForwardProfiles
    with TableInfo<$PortForwardProfilesTable, PortForwardProfileRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PortForwardProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bindHostMeta = const VerificationMeta(
    'bindHost',
  );
  @override
  late final GeneratedColumn<String> bindHost = GeneratedColumn<String>(
    'bind_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bindPortMeta = const VerificationMeta(
    'bindPort',
  );
  @override
  late final GeneratedColumn<int> bindPort = GeneratedColumn<int>(
    'bind_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetHostMeta = const VerificationMeta(
    'targetHost',
  );
  @override
  late final GeneratedColumn<String> targetHost = GeneratedColumn<String>(
    'target_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPortMeta = const VerificationMeta(
    'targetPort',
  );
  @override
  late final GeneratedColumn<int> targetPort = GeneratedColumn<int>(
    'target_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoStartMeta = const VerificationMeta(
    'autoStart',
  );
  @override
  late final GeneratedColumn<bool> autoStart = GeneratedColumn<bool>(
    'auto_start',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    kind,
    bindHost,
    bindPort,
    targetHost,
    targetPort,
    autoStart,
    label,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'port_forward_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PortForwardProfileRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('bind_host')) {
      context.handle(
        _bindHostMeta,
        bindHost.isAcceptableOrUnknown(data['bind_host']!, _bindHostMeta),
      );
    } else if (isInserting) {
      context.missing(_bindHostMeta);
    }
    if (data.containsKey('bind_port')) {
      context.handle(
        _bindPortMeta,
        bindPort.isAcceptableOrUnknown(data['bind_port']!, _bindPortMeta),
      );
    } else if (isInserting) {
      context.missing(_bindPortMeta);
    }
    if (data.containsKey('target_host')) {
      context.handle(
        _targetHostMeta,
        targetHost.isAcceptableOrUnknown(data['target_host']!, _targetHostMeta),
      );
    } else if (isInserting) {
      context.missing(_targetHostMeta);
    }
    if (data.containsKey('target_port')) {
      context.handle(
        _targetPortMeta,
        targetPort.isAcceptableOrUnknown(data['target_port']!, _targetPortMeta),
      );
    } else if (isInserting) {
      context.missing(_targetPortMeta);
    }
    if (data.containsKey('auto_start')) {
      context.handle(
        _autoStartMeta,
        autoStart.isAcceptableOrUnknown(data['auto_start']!, _autoStartMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PortForwardProfileRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PortForwardProfileRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      bindHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bind_host'],
      )!,
      bindPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bind_port'],
      )!,
      targetHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_host'],
      )!,
      targetPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_port'],
      )!,
      autoStart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
    );
  }

  @override
  $PortForwardProfilesTable createAlias(String alias) {
    return $PortForwardProfilesTable(attachedDatabase, alias);
  }
}

class PortForwardProfileRecord extends DataClass
    implements Insertable<PortForwardProfileRecord> {
  final String id;
  final String profileId;
  final String kind;
  final String bindHost;
  final int bindPort;
  final String targetHost;
  final int targetPort;
  final bool autoStart;
  final String? label;
  const PortForwardProfileRecord({
    required this.id,
    required this.profileId,
    required this.kind,
    required this.bindHost,
    required this.bindPort,
    required this.targetHost,
    required this.targetPort,
    required this.autoStart,
    this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['kind'] = Variable<String>(kind);
    map['bind_host'] = Variable<String>(bindHost);
    map['bind_port'] = Variable<int>(bindPort);
    map['target_host'] = Variable<String>(targetHost);
    map['target_port'] = Variable<int>(targetPort);
    map['auto_start'] = Variable<bool>(autoStart);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  PortForwardProfilesCompanion toCompanion(bool nullToAbsent) {
    return PortForwardProfilesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      kind: Value(kind),
      bindHost: Value(bindHost),
      bindPort: Value(bindPort),
      targetHost: Value(targetHost),
      targetPort: Value(targetPort),
      autoStart: Value(autoStart),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
    );
  }

  factory PortForwardProfileRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PortForwardProfileRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      kind: serializer.fromJson<String>(json['kind']),
      bindHost: serializer.fromJson<String>(json['bindHost']),
      bindPort: serializer.fromJson<int>(json['bindPort']),
      targetHost: serializer.fromJson<String>(json['targetHost']),
      targetPort: serializer.fromJson<int>(json['targetPort']),
      autoStart: serializer.fromJson<bool>(json['autoStart']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'kind': serializer.toJson<String>(kind),
      'bindHost': serializer.toJson<String>(bindHost),
      'bindPort': serializer.toJson<int>(bindPort),
      'targetHost': serializer.toJson<String>(targetHost),
      'targetPort': serializer.toJson<int>(targetPort),
      'autoStart': serializer.toJson<bool>(autoStart),
      'label': serializer.toJson<String?>(label),
    };
  }

  PortForwardProfileRecord copyWith({
    String? id,
    String? profileId,
    String? kind,
    String? bindHost,
    int? bindPort,
    String? targetHost,
    int? targetPort,
    bool? autoStart,
    Value<String?> label = const Value.absent(),
  }) => PortForwardProfileRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    kind: kind ?? this.kind,
    bindHost: bindHost ?? this.bindHost,
    bindPort: bindPort ?? this.bindPort,
    targetHost: targetHost ?? this.targetHost,
    targetPort: targetPort ?? this.targetPort,
    autoStart: autoStart ?? this.autoStart,
    label: label.present ? label.value : this.label,
  );
  PortForwardProfileRecord copyWithCompanion(
    PortForwardProfilesCompanion data,
  ) {
    return PortForwardProfileRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      kind: data.kind.present ? data.kind.value : this.kind,
      bindHost: data.bindHost.present ? data.bindHost.value : this.bindHost,
      bindPort: data.bindPort.present ? data.bindPort.value : this.bindPort,
      targetHost: data.targetHost.present
          ? data.targetHost.value
          : this.targetHost,
      targetPort: data.targetPort.present
          ? data.targetPort.value
          : this.targetPort,
      autoStart: data.autoStart.present ? data.autoStart.value : this.autoStart,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PortForwardProfileRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('kind: $kind, ')
          ..write('bindHost: $bindHost, ')
          ..write('bindPort: $bindPort, ')
          ..write('targetHost: $targetHost, ')
          ..write('targetPort: $targetPort, ')
          ..write('autoStart: $autoStart, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    kind,
    bindHost,
    bindPort,
    targetHost,
    targetPort,
    autoStart,
    label,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PortForwardProfileRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.kind == this.kind &&
          other.bindHost == this.bindHost &&
          other.bindPort == this.bindPort &&
          other.targetHost == this.targetHost &&
          other.targetPort == this.targetPort &&
          other.autoStart == this.autoStart &&
          other.label == this.label);
}

class PortForwardProfilesCompanion
    extends UpdateCompanion<PortForwardProfileRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> kind;
  final Value<String> bindHost;
  final Value<int> bindPort;
  final Value<String> targetHost;
  final Value<int> targetPort;
  final Value<bool> autoStart;
  final Value<String?> label;
  final Value<int> rowid;
  const PortForwardProfilesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.kind = const Value.absent(),
    this.bindHost = const Value.absent(),
    this.bindPort = const Value.absent(),
    this.targetHost = const Value.absent(),
    this.targetPort = const Value.absent(),
    this.autoStart = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PortForwardProfilesCompanion.insert({
    required String id,
    required String profileId,
    required String kind,
    required String bindHost,
    required int bindPort,
    required String targetHost,
    required int targetPort,
    this.autoStart = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       kind = Value(kind),
       bindHost = Value(bindHost),
       bindPort = Value(bindPort),
       targetHost = Value(targetHost),
       targetPort = Value(targetPort);
  static Insertable<PortForwardProfileRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? kind,
    Expression<String>? bindHost,
    Expression<int>? bindPort,
    Expression<String>? targetHost,
    Expression<int>? targetPort,
    Expression<bool>? autoStart,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (kind != null) 'kind': kind,
      if (bindHost != null) 'bind_host': bindHost,
      if (bindPort != null) 'bind_port': bindPort,
      if (targetHost != null) 'target_host': targetHost,
      if (targetPort != null) 'target_port': targetPort,
      if (autoStart != null) 'auto_start': autoStart,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PortForwardProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? kind,
    Value<String>? bindHost,
    Value<int>? bindPort,
    Value<String>? targetHost,
    Value<int>? targetPort,
    Value<bool>? autoStart,
    Value<String?>? label,
    Value<int>? rowid,
  }) {
    return PortForwardProfilesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      kind: kind ?? this.kind,
      bindHost: bindHost ?? this.bindHost,
      bindPort: bindPort ?? this.bindPort,
      targetHost: targetHost ?? this.targetHost,
      targetPort: targetPort ?? this.targetPort,
      autoStart: autoStart ?? this.autoStart,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (bindHost.present) {
      map['bind_host'] = Variable<String>(bindHost.value);
    }
    if (bindPort.present) {
      map['bind_port'] = Variable<int>(bindPort.value);
    }
    if (targetHost.present) {
      map['target_host'] = Variable<String>(targetHost.value);
    }
    if (targetPort.present) {
      map['target_port'] = Variable<int>(targetPort.value);
    }
    if (autoStart.present) {
      map['auto_start'] = Variable<bool>(autoStart.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PortForwardProfilesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('kind: $kind, ')
          ..write('bindHost: $bindHost, ')
          ..write('bindPort: $bindPort, ')
          ..write('targetHost: $targetHost, ')
          ..write('targetPort: $targetPort, ')
          ..write('autoStart: $autoStart, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets
    with TableInfo<$SnippetsTable, SnippetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shellTextMeta = const VerificationMeta(
    'shellText',
  );
  @override
  late final GeneratedColumn<String> shellText = GeneratedColumn<String>(
    'shell_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeholdersJsonMeta = const VerificationMeta(
    'placeholdersJson',
  );
  @override
  late final GeneratedColumn<String> placeholdersJson = GeneratedColumn<String>(
    'placeholders_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _workingDirectoryHintMeta =
      const VerificationMeta('workingDirectoryHint');
  @override
  late final GeneratedColumn<String> workingDirectoryHint =
      GeneratedColumn<String>(
        'working_directory_hint',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<int> lastUsedAt = GeneratedColumn<int>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    shellText,
    placeholdersJson,
    workingDirectoryHint,
    isFavorite,
    lastUsedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnippetRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('shell_text')) {
      context.handle(
        _shellTextMeta,
        shellText.isAcceptableOrUnknown(data['shell_text']!, _shellTextMeta),
      );
    } else if (isInserting) {
      context.missing(_shellTextMeta);
    }
    if (data.containsKey('placeholders_json')) {
      context.handle(
        _placeholdersJsonMeta,
        placeholdersJson.isAcceptableOrUnknown(
          data['placeholders_json']!,
          _placeholdersJsonMeta,
        ),
      );
    }
    if (data.containsKey('working_directory_hint')) {
      context.handle(
        _workingDirectoryHintMeta,
        workingDirectoryHint.isAcceptableOrUnknown(
          data['working_directory_hint']!,
          _workingDirectoryHintMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnippetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnippetRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      shellText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shell_text'],
      )!,
      placeholdersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placeholders_json'],
      )!,
      workingDirectoryHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}working_directory_hint'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_used_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class SnippetRecord extends DataClass implements Insertable<SnippetRecord> {
  final String id;
  final String title;
  final String shellText;
  final String placeholdersJson;
  final String? workingDirectoryHint;
  final bool isFavorite;
  final int? lastUsedAt;
  final int createdAt;
  const SnippetRecord({
    required this.id,
    required this.title,
    required this.shellText,
    required this.placeholdersJson,
    this.workingDirectoryHint,
    required this.isFavorite,
    this.lastUsedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['shell_text'] = Variable<String>(shellText);
    map['placeholders_json'] = Variable<String>(placeholdersJson);
    if (!nullToAbsent || workingDirectoryHint != null) {
      map['working_directory_hint'] = Variable<String>(workingDirectoryHint);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<int>(lastUsedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      title: Value(title),
      shellText: Value(shellText),
      placeholdersJson: Value(placeholdersJson),
      workingDirectoryHint: workingDirectoryHint == null && nullToAbsent
          ? const Value.absent()
          : Value(workingDirectoryHint),
      isFavorite: Value(isFavorite),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      createdAt: Value(createdAt),
    );
  }

  factory SnippetRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnippetRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      shellText: serializer.fromJson<String>(json['shellText']),
      placeholdersJson: serializer.fromJson<String>(json['placeholdersJson']),
      workingDirectoryHint: serializer.fromJson<String?>(
        json['workingDirectoryHint'],
      ),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastUsedAt: serializer.fromJson<int?>(json['lastUsedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'shellText': serializer.toJson<String>(shellText),
      'placeholdersJson': serializer.toJson<String>(placeholdersJson),
      'workingDirectoryHint': serializer.toJson<String?>(workingDirectoryHint),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastUsedAt': serializer.toJson<int?>(lastUsedAt),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SnippetRecord copyWith({
    String? id,
    String? title,
    String? shellText,
    String? placeholdersJson,
    Value<String?> workingDirectoryHint = const Value.absent(),
    bool? isFavorite,
    Value<int?> lastUsedAt = const Value.absent(),
    int? createdAt,
  }) => SnippetRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    shellText: shellText ?? this.shellText,
    placeholdersJson: placeholdersJson ?? this.placeholdersJson,
    workingDirectoryHint: workingDirectoryHint.present
        ? workingDirectoryHint.value
        : this.workingDirectoryHint,
    isFavorite: isFavorite ?? this.isFavorite,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SnippetRecord copyWithCompanion(SnippetsCompanion data) {
    return SnippetRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      shellText: data.shellText.present ? data.shellText.value : this.shellText,
      placeholdersJson: data.placeholdersJson.present
          ? data.placeholdersJson.value
          : this.placeholdersJson,
      workingDirectoryHint: data.workingDirectoryHint.present
          ? data.workingDirectoryHint.value
          : this.workingDirectoryHint,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnippetRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('shellText: $shellText, ')
          ..write('placeholdersJson: $placeholdersJson, ')
          ..write('workingDirectoryHint: $workingDirectoryHint, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    shellText,
    placeholdersJson,
    workingDirectoryHint,
    isFavorite,
    lastUsedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.shellText == this.shellText &&
          other.placeholdersJson == this.placeholdersJson &&
          other.workingDirectoryHint == this.workingDirectoryHint &&
          other.isFavorite == this.isFavorite &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt);
}

class SnippetsCompanion extends UpdateCompanion<SnippetRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> shellText;
  final Value<String> placeholdersJson;
  final Value<String?> workingDirectoryHint;
  final Value<bool> isFavorite;
  final Value<int?> lastUsedAt;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.shellText = const Value.absent(),
    this.placeholdersJson = const Value.absent(),
    this.workingDirectoryHint = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetsCompanion.insert({
    required String id,
    required String title,
    required String shellText,
    this.placeholdersJson = const Value.absent(),
    this.workingDirectoryHint = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       shellText = Value(shellText),
       createdAt = Value(createdAt);
  static Insertable<SnippetRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? shellText,
    Expression<String>? placeholdersJson,
    Expression<String>? workingDirectoryHint,
    Expression<bool>? isFavorite,
    Expression<int>? lastUsedAt,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (shellText != null) 'shell_text': shellText,
      if (placeholdersJson != null) 'placeholders_json': placeholdersJson,
      if (workingDirectoryHint != null)
        'working_directory_hint': workingDirectoryHint,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? shellText,
    Value<String>? placeholdersJson,
    Value<String?>? workingDirectoryHint,
    Value<bool>? isFavorite,
    Value<int?>? lastUsedAt,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return SnippetsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      shellText: shellText ?? this.shellText,
      placeholdersJson: placeholdersJson ?? this.placeholdersJson,
      workingDirectoryHint: workingDirectoryHint ?? this.workingDirectoryHint,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
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
    if (shellText.present) {
      map['shell_text'] = Variable<String>(shellText.value);
    }
    if (placeholdersJson.present) {
      map['placeholders_json'] = Variable<String>(placeholdersJson.value);
    }
    if (workingDirectoryHint.present) {
      map['working_directory_hint'] = Variable<String>(
        workingDirectoryHint.value,
      );
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<int>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('shellText: $shellText, ')
          ..write('placeholdersJson: $placeholdersJson, ')
          ..write('workingDirectoryHint: $workingDirectoryHint, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnownHostsTable extends KnownHosts
    with TableInfo<$KnownHostsTable, KnownHostRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnownHostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyTypeMeta = const VerificationMeta(
    'keyType',
  );
  @override
  late final GeneratedColumn<String> keyType = GeneratedColumn<String>(
    'key_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintHexMeta = const VerificationMeta(
    'fingerprintHex',
  );
  @override
  late final GeneratedColumn<String> fingerprintHex = GeneratedColumn<String>(
    'fingerprint_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    host,
    port,
    keyType,
    fingerprintHex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'known_hosts';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnownHostRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('key_type')) {
      context.handle(
        _keyTypeMeta,
        keyType.isAcceptableOrUnknown(data['key_type']!, _keyTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_keyTypeMeta);
    }
    if (data.containsKey('fingerprint_hex')) {
      context.handle(
        _fingerprintHexMeta,
        fingerprintHex.isAcceptableOrUnknown(
          data['fingerprint_hex']!,
          _fingerprintHexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintHexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnownHostRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnownHostRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      keyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_type'],
      )!,
      fingerprintHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint_hex'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KnownHostsTable createAlias(String alias) {
    return $KnownHostsTable(attachedDatabase, alias);
  }
}

class KnownHostRecord extends DataClass implements Insertable<KnownHostRecord> {
  final String id;
  final String host;
  final int port;
  final String keyType;
  final String fingerprintHex;
  final int createdAt;
  final int updatedAt;
  const KnownHostRecord({
    required this.id,
    required this.host,
    required this.port,
    required this.keyType,
    required this.fingerprintHex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['key_type'] = Variable<String>(keyType);
    map['fingerprint_hex'] = Variable<String>(fingerprintHex);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  KnownHostsCompanion toCompanion(bool nullToAbsent) {
    return KnownHostsCompanion(
      id: Value(id),
      host: Value(host),
      port: Value(port),
      keyType: Value(keyType),
      fingerprintHex: Value(fingerprintHex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KnownHostRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnownHostRecord(
      id: serializer.fromJson<String>(json['id']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      keyType: serializer.fromJson<String>(json['keyType']),
      fingerprintHex: serializer.fromJson<String>(json['fingerprintHex']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'keyType': serializer.toJson<String>(keyType),
      'fingerprintHex': serializer.toJson<String>(fingerprintHex),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  KnownHostRecord copyWith({
    String? id,
    String? host,
    int? port,
    String? keyType,
    String? fingerprintHex,
    int? createdAt,
    int? updatedAt,
  }) => KnownHostRecord(
    id: id ?? this.id,
    host: host ?? this.host,
    port: port ?? this.port,
    keyType: keyType ?? this.keyType,
    fingerprintHex: fingerprintHex ?? this.fingerprintHex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KnownHostRecord copyWithCompanion(KnownHostsCompanion data) {
    return KnownHostRecord(
      id: data.id.present ? data.id.value : this.id,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      keyType: data.keyType.present ? data.keyType.value : this.keyType,
      fingerprintHex: data.fingerprintHex.present
          ? data.fingerprintHex.value
          : this.fingerprintHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnownHostRecord(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprintHex: $fingerprintHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    host,
    port,
    keyType,
    fingerprintHex,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnownHostRecord &&
          other.id == this.id &&
          other.host == this.host &&
          other.port == this.port &&
          other.keyType == this.keyType &&
          other.fingerprintHex == this.fingerprintHex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KnownHostsCompanion extends UpdateCompanion<KnownHostRecord> {
  final Value<String> id;
  final Value<String> host;
  final Value<int> port;
  final Value<String> keyType;
  final Value<String> fingerprintHex;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const KnownHostsCompanion({
    this.id = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.keyType = const Value.absent(),
    this.fingerprintHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnownHostsCompanion.insert({
    required String id,
    required String host,
    required int port,
    required String keyType,
    required String fingerprintHex,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       host = Value(host),
       port = Value(port),
       keyType = Value(keyType),
       fingerprintHex = Value(fingerprintHex),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<KnownHostRecord> custom({
    Expression<String>? id,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? keyType,
    Expression<String>? fingerprintHex,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (keyType != null) 'key_type': keyType,
      if (fingerprintHex != null) 'fingerprint_hex': fingerprintHex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnownHostsCompanion copyWith({
    Value<String>? id,
    Value<String>? host,
    Value<int>? port,
    Value<String>? keyType,
    Value<String>? fingerprintHex,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return KnownHostsCompanion(
      id: id ?? this.id,
      host: host ?? this.host,
      port: port ?? this.port,
      keyType: keyType ?? this.keyType,
      fingerprintHex: fingerprintHex ?? this.fingerprintHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (keyType.present) {
      map['key_type'] = Variable<String>(keyType.value);
    }
    if (fingerprintHex.present) {
      map['fingerprint_hex'] = Variable<String>(fingerprintHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnownHostsCompanion(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprintHex: $fingerprintHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServerProfilesTable serverProfiles = $ServerProfilesTable(this);
  late final $JumpHopsTable jumpHops = $JumpHopsTable(this);
  late final $CredentialRefsTable credentialRefs = $CredentialRefsTable(this);
  late final $PortForwardProfilesTable portForwardProfiles =
      $PortForwardProfilesTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  late final $KnownHostsTable knownHosts = $KnownHostsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serverProfiles,
    jumpHops,
    credentialRefs,
    portForwardProfiles,
    snippets,
    knownHosts,
  ];
}

typedef $$ServerProfilesTableCreateCompanionBuilder =
    ServerProfilesCompanion Function({
      required String id,
      required String label,
      required String host,
      required int port,
      required String username,
      Value<String> tagsJson,
      Value<String?> defaultDirectory,
      required String terminalTheme,
      required String authMethod,
      Value<String?> credentialRefId,
      required String networkMode,
      Value<String?> managedBrowserUrl,
      Value<String?> managedTargetHint,
      Value<String> preflightRequirementsJson,
      required int createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });
typedef $$ServerProfilesTableUpdateCompanionBuilder =
    ServerProfilesCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> host,
      Value<int> port,
      Value<String> username,
      Value<String> tagsJson,
      Value<String?> defaultDirectory,
      Value<String> terminalTheme,
      Value<String> authMethod,
      Value<String?> credentialRefId,
      Value<String> networkMode,
      Value<String?> managedBrowserUrl,
      Value<String?> managedTargetHint,
      Value<String> preflightRequirementsJson,
      Value<int> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });

class $$ServerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultDirectory => $composableBuilder(
    column: $table.defaultDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terminalTheme => $composableBuilder(
    column: $table.terminalTheme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get credentialRefId => $composableBuilder(
    column: $table.credentialRefId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get networkMode => $composableBuilder(
    column: $table.networkMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get managedBrowserUrl => $composableBuilder(
    column: $table.managedBrowserUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get managedTargetHint => $composableBuilder(
    column: $table.managedTargetHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preflightRequirementsJson => $composableBuilder(
    column: $table.preflightRequirementsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultDirectory => $composableBuilder(
    column: $table.defaultDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terminalTheme => $composableBuilder(
    column: $table.terminalTheme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get credentialRefId => $composableBuilder(
    column: $table.credentialRefId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get networkMode => $composableBuilder(
    column: $table.networkMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get managedBrowserUrl => $composableBuilder(
    column: $table.managedBrowserUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get managedTargetHint => $composableBuilder(
    column: $table.managedTargetHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preflightRequirementsJson => $composableBuilder(
    column: $table.preflightRequirementsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get defaultDirectory => $composableBuilder(
    column: $table.defaultDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get terminalTheme => $composableBuilder(
    column: $table.terminalTheme,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get credentialRefId => $composableBuilder(
    column: $table.credentialRefId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get networkMode => $composableBuilder(
    column: $table.networkMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get managedBrowserUrl => $composableBuilder(
    column: $table.managedBrowserUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get managedTargetHint => $composableBuilder(
    column: $table.managedTargetHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preflightRequirementsJson => $composableBuilder(
    column: $table.preflightRequirementsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ServerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServerProfilesTable,
          ServerProfileRecord,
          $$ServerProfilesTableFilterComposer,
          $$ServerProfilesTableOrderingComposer,
          $$ServerProfilesTableAnnotationComposer,
          $$ServerProfilesTableCreateCompanionBuilder,
          $$ServerProfilesTableUpdateCompanionBuilder,
          (
            ServerProfileRecord,
            BaseReferences<
              _$AppDatabase,
              $ServerProfilesTable,
              ServerProfileRecord
            >,
          ),
          ServerProfileRecord,
          PrefetchHooks Function()
        > {
  $$ServerProfilesTableTableManager(
    _$AppDatabase db,
    $ServerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> defaultDirectory = const Value.absent(),
                Value<String> terminalTheme = const Value.absent(),
                Value<String> authMethod = const Value.absent(),
                Value<String?> credentialRefId = const Value.absent(),
                Value<String> networkMode = const Value.absent(),
                Value<String?> managedBrowserUrl = const Value.absent(),
                Value<String?> managedTargetHint = const Value.absent(),
                Value<String> preflightRequirementsJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServerProfilesCompanion(
                id: id,
                label: label,
                host: host,
                port: port,
                username: username,
                tagsJson: tagsJson,
                defaultDirectory: defaultDirectory,
                terminalTheme: terminalTheme,
                authMethod: authMethod,
                credentialRefId: credentialRefId,
                networkMode: networkMode,
                managedBrowserUrl: managedBrowserUrl,
                managedTargetHint: managedTargetHint,
                preflightRequirementsJson: preflightRequirementsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String host,
                required int port,
                required String username,
                Value<String> tagsJson = const Value.absent(),
                Value<String?> defaultDirectory = const Value.absent(),
                required String terminalTheme,
                required String authMethod,
                Value<String?> credentialRefId = const Value.absent(),
                required String networkMode,
                Value<String?> managedBrowserUrl = const Value.absent(),
                Value<String?> managedTargetHint = const Value.absent(),
                Value<String> preflightRequirementsJson = const Value.absent(),
                required int createdAt,
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServerProfilesCompanion.insert(
                id: id,
                label: label,
                host: host,
                port: port,
                username: username,
                tagsJson: tagsJson,
                defaultDirectory: defaultDirectory,
                terminalTheme: terminalTheme,
                authMethod: authMethod,
                credentialRefId: credentialRefId,
                networkMode: networkMode,
                managedBrowserUrl: managedBrowserUrl,
                managedTargetHint: managedTargetHint,
                preflightRequirementsJson: preflightRequirementsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServerProfilesTable,
      ServerProfileRecord,
      $$ServerProfilesTableFilterComposer,
      $$ServerProfilesTableOrderingComposer,
      $$ServerProfilesTableAnnotationComposer,
      $$ServerProfilesTableCreateCompanionBuilder,
      $$ServerProfilesTableUpdateCompanionBuilder,
      (
        ServerProfileRecord,
        BaseReferences<
          _$AppDatabase,
          $ServerProfilesTable,
          ServerProfileRecord
        >,
      ),
      ServerProfileRecord,
      PrefetchHooks Function()
    >;
typedef $$JumpHopsTableCreateCompanionBuilder =
    JumpHopsCompanion Function({
      required String id,
      required String profileId,
      required int hopOrder,
      required String hopProfileId,
      Value<int> rowid,
    });
typedef $$JumpHopsTableUpdateCompanionBuilder =
    JumpHopsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> hopOrder,
      Value<String> hopProfileId,
      Value<int> rowid,
    });

class $$JumpHopsTableFilterComposer
    extends Composer<_$AppDatabase, $JumpHopsTable> {
  $$JumpHopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hopOrder => $composableBuilder(
    column: $table.hopOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hopProfileId => $composableBuilder(
    column: $table.hopProfileId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JumpHopsTableOrderingComposer
    extends Composer<_$AppDatabase, $JumpHopsTable> {
  $$JumpHopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hopOrder => $composableBuilder(
    column: $table.hopOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hopProfileId => $composableBuilder(
    column: $table.hopProfileId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JumpHopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JumpHopsTable> {
  $$JumpHopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get hopOrder =>
      $composableBuilder(column: $table.hopOrder, builder: (column) => column);

  GeneratedColumn<String> get hopProfileId => $composableBuilder(
    column: $table.hopProfileId,
    builder: (column) => column,
  );
}

class $$JumpHopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JumpHopsTable,
          JumpHopRecord,
          $$JumpHopsTableFilterComposer,
          $$JumpHopsTableOrderingComposer,
          $$JumpHopsTableAnnotationComposer,
          $$JumpHopsTableCreateCompanionBuilder,
          $$JumpHopsTableUpdateCompanionBuilder,
          (
            JumpHopRecord,
            BaseReferences<_$AppDatabase, $JumpHopsTable, JumpHopRecord>,
          ),
          JumpHopRecord,
          PrefetchHooks Function()
        > {
  $$JumpHopsTableTableManager(_$AppDatabase db, $JumpHopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JumpHopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JumpHopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JumpHopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> hopOrder = const Value.absent(),
                Value<String> hopProfileId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JumpHopsCompanion(
                id: id,
                profileId: profileId,
                hopOrder: hopOrder,
                hopProfileId: hopProfileId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int hopOrder,
                required String hopProfileId,
                Value<int> rowid = const Value.absent(),
              }) => JumpHopsCompanion.insert(
                id: id,
                profileId: profileId,
                hopOrder: hopOrder,
                hopProfileId: hopProfileId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JumpHopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JumpHopsTable,
      JumpHopRecord,
      $$JumpHopsTableFilterComposer,
      $$JumpHopsTableOrderingComposer,
      $$JumpHopsTableAnnotationComposer,
      $$JumpHopsTableCreateCompanionBuilder,
      $$JumpHopsTableUpdateCompanionBuilder,
      (
        JumpHopRecord,
        BaseReferences<_$AppDatabase, $JumpHopsTable, JumpHopRecord>,
      ),
      JumpHopRecord,
      PrefetchHooks Function()
    >;
typedef $$CredentialRefsTableCreateCompanionBuilder =
    CredentialRefsCompanion Function({
      required String id,
      required String label,
      required String kind,
      Value<String?> usernameHint,
      Value<bool> requiresBiometric,
      Value<String?> publicKeyFingerprint,
      Value<bool> isEncrypted,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$CredentialRefsTableUpdateCompanionBuilder =
    CredentialRefsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> kind,
      Value<String?> usernameHint,
      Value<bool> requiresBiometric,
      Value<String?> publicKeyFingerprint,
      Value<bool> isEncrypted,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$CredentialRefsTableFilterComposer
    extends Composer<_$AppDatabase, $CredentialRefsTable> {
  $$CredentialRefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usernameHint => $composableBuilder(
    column: $table.usernameHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresBiometric => $composableBuilder(
    column: $table.requiresBiometric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicKeyFingerprint => $composableBuilder(
    column: $table.publicKeyFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
    column: $table.isEncrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CredentialRefsTableOrderingComposer
    extends Composer<_$AppDatabase, $CredentialRefsTable> {
  $$CredentialRefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usernameHint => $composableBuilder(
    column: $table.usernameHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresBiometric => $composableBuilder(
    column: $table.requiresBiometric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicKeyFingerprint => $composableBuilder(
    column: $table.publicKeyFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
    column: $table.isEncrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CredentialRefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CredentialRefsTable> {
  $$CredentialRefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get usernameHint => $composableBuilder(
    column: $table.usernameHint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresBiometric => $composableBuilder(
    column: $table.requiresBiometric,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publicKeyFingerprint => $composableBuilder(
    column: $table.publicKeyFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
    column: $table.isEncrypted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CredentialRefsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CredentialRefsTable,
          CredentialRefRecord,
          $$CredentialRefsTableFilterComposer,
          $$CredentialRefsTableOrderingComposer,
          $$CredentialRefsTableAnnotationComposer,
          $$CredentialRefsTableCreateCompanionBuilder,
          $$CredentialRefsTableUpdateCompanionBuilder,
          (
            CredentialRefRecord,
            BaseReferences<
              _$AppDatabase,
              $CredentialRefsTable,
              CredentialRefRecord
            >,
          ),
          CredentialRefRecord,
          PrefetchHooks Function()
        > {
  $$CredentialRefsTableTableManager(
    _$AppDatabase db,
    $CredentialRefsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CredentialRefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CredentialRefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CredentialRefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> usernameHint = const Value.absent(),
                Value<bool> requiresBiometric = const Value.absent(),
                Value<String?> publicKeyFingerprint = const Value.absent(),
                Value<bool> isEncrypted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CredentialRefsCompanion(
                id: id,
                label: label,
                kind: kind,
                usernameHint: usernameHint,
                requiresBiometric: requiresBiometric,
                publicKeyFingerprint: publicKeyFingerprint,
                isEncrypted: isEncrypted,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String kind,
                Value<String?> usernameHint = const Value.absent(),
                Value<bool> requiresBiometric = const Value.absent(),
                Value<String?> publicKeyFingerprint = const Value.absent(),
                Value<bool> isEncrypted = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CredentialRefsCompanion.insert(
                id: id,
                label: label,
                kind: kind,
                usernameHint: usernameHint,
                requiresBiometric: requiresBiometric,
                publicKeyFingerprint: publicKeyFingerprint,
                isEncrypted: isEncrypted,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CredentialRefsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CredentialRefsTable,
      CredentialRefRecord,
      $$CredentialRefsTableFilterComposer,
      $$CredentialRefsTableOrderingComposer,
      $$CredentialRefsTableAnnotationComposer,
      $$CredentialRefsTableCreateCompanionBuilder,
      $$CredentialRefsTableUpdateCompanionBuilder,
      (
        CredentialRefRecord,
        BaseReferences<
          _$AppDatabase,
          $CredentialRefsTable,
          CredentialRefRecord
        >,
      ),
      CredentialRefRecord,
      PrefetchHooks Function()
    >;
typedef $$PortForwardProfilesTableCreateCompanionBuilder =
    PortForwardProfilesCompanion Function({
      required String id,
      required String profileId,
      required String kind,
      required String bindHost,
      required int bindPort,
      required String targetHost,
      required int targetPort,
      Value<bool> autoStart,
      Value<String?> label,
      Value<int> rowid,
    });
typedef $$PortForwardProfilesTableUpdateCompanionBuilder =
    PortForwardProfilesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> kind,
      Value<String> bindHost,
      Value<int> bindPort,
      Value<String> targetHost,
      Value<int> targetPort,
      Value<bool> autoStart,
      Value<String?> label,
      Value<int> rowid,
    });

class $$PortForwardProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PortForwardProfilesTable> {
  $$PortForwardProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bindHost => $composableBuilder(
    column: $table.bindHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bindPort => $composableBuilder(
    column: $table.bindPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetHost => $composableBuilder(
    column: $table.targetHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPort => $composableBuilder(
    column: $table.targetPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStart => $composableBuilder(
    column: $table.autoStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PortForwardProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PortForwardProfilesTable> {
  $$PortForwardProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bindHost => $composableBuilder(
    column: $table.bindHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bindPort => $composableBuilder(
    column: $table.bindPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetHost => $composableBuilder(
    column: $table.targetHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPort => $composableBuilder(
    column: $table.targetPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStart => $composableBuilder(
    column: $table.autoStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PortForwardProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PortForwardProfilesTable> {
  $$PortForwardProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get bindHost =>
      $composableBuilder(column: $table.bindHost, builder: (column) => column);

  GeneratedColumn<int> get bindPort =>
      $composableBuilder(column: $table.bindPort, builder: (column) => column);

  GeneratedColumn<String> get targetHost => $composableBuilder(
    column: $table.targetHost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetPort => $composableBuilder(
    column: $table.targetPort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStart =>
      $composableBuilder(column: $table.autoStart, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$PortForwardProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PortForwardProfilesTable,
          PortForwardProfileRecord,
          $$PortForwardProfilesTableFilterComposer,
          $$PortForwardProfilesTableOrderingComposer,
          $$PortForwardProfilesTableAnnotationComposer,
          $$PortForwardProfilesTableCreateCompanionBuilder,
          $$PortForwardProfilesTableUpdateCompanionBuilder,
          (
            PortForwardProfileRecord,
            BaseReferences<
              _$AppDatabase,
              $PortForwardProfilesTable,
              PortForwardProfileRecord
            >,
          ),
          PortForwardProfileRecord,
          PrefetchHooks Function()
        > {
  $$PortForwardProfilesTableTableManager(
    _$AppDatabase db,
    $PortForwardProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PortForwardProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PortForwardProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PortForwardProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> bindHost = const Value.absent(),
                Value<int> bindPort = const Value.absent(),
                Value<String> targetHost = const Value.absent(),
                Value<int> targetPort = const Value.absent(),
                Value<bool> autoStart = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortForwardProfilesCompanion(
                id: id,
                profileId: profileId,
                kind: kind,
                bindHost: bindHost,
                bindPort: bindPort,
                targetHost: targetHost,
                targetPort: targetPort,
                autoStart: autoStart,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String kind,
                required String bindHost,
                required int bindPort,
                required String targetHost,
                required int targetPort,
                Value<bool> autoStart = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortForwardProfilesCompanion.insert(
                id: id,
                profileId: profileId,
                kind: kind,
                bindHost: bindHost,
                bindPort: bindPort,
                targetHost: targetHost,
                targetPort: targetPort,
                autoStart: autoStart,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PortForwardProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PortForwardProfilesTable,
      PortForwardProfileRecord,
      $$PortForwardProfilesTableFilterComposer,
      $$PortForwardProfilesTableOrderingComposer,
      $$PortForwardProfilesTableAnnotationComposer,
      $$PortForwardProfilesTableCreateCompanionBuilder,
      $$PortForwardProfilesTableUpdateCompanionBuilder,
      (
        PortForwardProfileRecord,
        BaseReferences<
          _$AppDatabase,
          $PortForwardProfilesTable,
          PortForwardProfileRecord
        >,
      ),
      PortForwardProfileRecord,
      PrefetchHooks Function()
    >;
typedef $$SnippetsTableCreateCompanionBuilder =
    SnippetsCompanion Function({
      required String id,
      required String title,
      required String shellText,
      Value<String> placeholdersJson,
      Value<String?> workingDirectoryHint,
      Value<bool> isFavorite,
      Value<int?> lastUsedAt,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$SnippetsTableUpdateCompanionBuilder =
    SnippetsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> shellText,
      Value<String> placeholdersJson,
      Value<String?> workingDirectoryHint,
      Value<bool> isFavorite,
      Value<int?> lastUsedAt,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$SnippetsTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shellText => $composableBuilder(
    column: $table.shellText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeholdersJson => $composableBuilder(
    column: $table.placeholdersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workingDirectoryHint => $composableBuilder(
    column: $table.workingDirectoryHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnippetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shellText => $composableBuilder(
    column: $table.shellText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeholdersJson => $composableBuilder(
    column: $table.placeholdersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workingDirectoryHint => $composableBuilder(
    column: $table.workingDirectoryHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnippetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableAnnotationComposer({
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

  GeneratedColumn<String> get shellText =>
      $composableBuilder(column: $table.shellText, builder: (column) => column);

  GeneratedColumn<String> get placeholdersJson => $composableBuilder(
    column: $table.placeholdersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workingDirectoryHint => $composableBuilder(
    column: $table.workingDirectoryHint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnippetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnippetsTable,
          SnippetRecord,
          $$SnippetsTableFilterComposer,
          $$SnippetsTableOrderingComposer,
          $$SnippetsTableAnnotationComposer,
          $$SnippetsTableCreateCompanionBuilder,
          $$SnippetsTableUpdateCompanionBuilder,
          (
            SnippetRecord,
            BaseReferences<_$AppDatabase, $SnippetsTable, SnippetRecord>,
          ),
          SnippetRecord,
          PrefetchHooks Function()
        > {
  $$SnippetsTableTableManager(_$AppDatabase db, $SnippetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> shellText = const Value.absent(),
                Value<String> placeholdersJson = const Value.absent(),
                Value<String?> workingDirectoryHint = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion(
                id: id,
                title: title,
                shellText: shellText,
                placeholdersJson: placeholdersJson,
                workingDirectoryHint: workingDirectoryHint,
                isFavorite: isFavorite,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String shellText,
                Value<String> placeholdersJson = const Value.absent(),
                Value<String?> workingDirectoryHint = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion.insert(
                id: id,
                title: title,
                shellText: shellText,
                placeholdersJson: placeholdersJson,
                workingDirectoryHint: workingDirectoryHint,
                isFavorite: isFavorite,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnippetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnippetsTable,
      SnippetRecord,
      $$SnippetsTableFilterComposer,
      $$SnippetsTableOrderingComposer,
      $$SnippetsTableAnnotationComposer,
      $$SnippetsTableCreateCompanionBuilder,
      $$SnippetsTableUpdateCompanionBuilder,
      (
        SnippetRecord,
        BaseReferences<_$AppDatabase, $SnippetsTable, SnippetRecord>,
      ),
      SnippetRecord,
      PrefetchHooks Function()
    >;
typedef $$KnownHostsTableCreateCompanionBuilder =
    KnownHostsCompanion Function({
      required String id,
      required String host,
      required int port,
      required String keyType,
      required String fingerprintHex,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$KnownHostsTableUpdateCompanionBuilder =
    KnownHostsCompanion Function({
      Value<String> id,
      Value<String> host,
      Value<int> port,
      Value<String> keyType,
      Value<String> fingerprintHex,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$KnownHostsTableFilterComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprintHex => $composableBuilder(
    column: $table.fingerprintHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnownHostsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprintHex => $composableBuilder(
    column: $table.fingerprintHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnownHostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get keyType =>
      $composableBuilder(column: $table.keyType, builder: (column) => column);

  GeneratedColumn<String> get fingerprintHex => $composableBuilder(
    column: $table.fingerprintHex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KnownHostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnownHostsTable,
          KnownHostRecord,
          $$KnownHostsTableFilterComposer,
          $$KnownHostsTableOrderingComposer,
          $$KnownHostsTableAnnotationComposer,
          $$KnownHostsTableCreateCompanionBuilder,
          $$KnownHostsTableUpdateCompanionBuilder,
          (
            KnownHostRecord,
            BaseReferences<_$AppDatabase, $KnownHostsTable, KnownHostRecord>,
          ),
          KnownHostRecord,
          PrefetchHooks Function()
        > {
  $$KnownHostsTableTableManager(_$AppDatabase db, $KnownHostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnownHostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnownHostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnownHostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> keyType = const Value.absent(),
                Value<String> fingerprintHex = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnownHostsCompanion(
                id: id,
                host: host,
                port: port,
                keyType: keyType,
                fingerprintHex: fingerprintHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String host,
                required int port,
                required String keyType,
                required String fingerprintHex,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => KnownHostsCompanion.insert(
                id: id,
                host: host,
                port: port,
                keyType: keyType,
                fingerprintHex: fingerprintHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnownHostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnownHostsTable,
      KnownHostRecord,
      $$KnownHostsTableFilterComposer,
      $$KnownHostsTableOrderingComposer,
      $$KnownHostsTableAnnotationComposer,
      $$KnownHostsTableCreateCompanionBuilder,
      $$KnownHostsTableUpdateCompanionBuilder,
      (
        KnownHostRecord,
        BaseReferences<_$AppDatabase, $KnownHostsTable, KnownHostRecord>,
      ),
      KnownHostRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(_db, _db.serverProfiles);
  $$JumpHopsTableTableManager get jumpHops =>
      $$JumpHopsTableTableManager(_db, _db.jumpHops);
  $$CredentialRefsTableTableManager get credentialRefs =>
      $$CredentialRefsTableTableManager(_db, _db.credentialRefs);
  $$PortForwardProfilesTableTableManager get portForwardProfiles =>
      $$PortForwardProfilesTableTableManager(_db, _db.portForwardProfiles);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
  $$KnownHostsTableTableManager get knownHosts =>
      $$KnownHostsTableTableManager(_db, _db.knownHosts);
}
