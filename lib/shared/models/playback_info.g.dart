// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_info.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaybackInfoCollection on Isar {
  IsarCollection<PlaybackInfo> get playbackInfos => this.collection();
}

const PlaybackInfoSchema = CollectionSchema(
  name: r'PlaybackInfo',
  id: -1582980230284968066,
  properties: {
    r'lastPositionMs': PropertySchema(
      id: 0,
      name: r'lastPositionMs',
      type: IsarType.long,
    ),
    r'lastSongArtist': PropertySchema(
      id: 1,
      name: r'lastSongArtist',
      type: IsarType.string,
    ),
    r'lastSongAudioId': PropertySchema(
      id: 2,
      name: r'lastSongAudioId',
      type: IsarType.long,
    ),
    r'lastSongTitle': PropertySchema(
      id: 3,
      name: r'lastSongTitle',
      type: IsarType.string,
    ),
    r'lastSongUri': PropertySchema(
      id: 4,
      name: r'lastSongUri',
      type: IsarType.string,
    ),
    r'repeatMode': PropertySchema(
      id: 5,
      name: r'repeatMode',
      type: IsarType.string,
    ),
    r'shuffleEnabled': PropertySchema(
      id: 6,
      name: r'shuffleEnabled',
      type: IsarType.bool,
    ),
  },

  estimateSize: _playbackInfoEstimateSize,
  serialize: _playbackInfoSerialize,
  deserialize: _playbackInfoDeserialize,
  deserializeProp: _playbackInfoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _playbackInfoGetId,
  getLinks: _playbackInfoGetLinks,
  attach: _playbackInfoAttach,
  version: '3.3.2',
);

int _playbackInfoEstimateSize(
  PlaybackInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastSongArtist;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastSongTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastSongUri;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.repeatMode.length * 3;
  return bytesCount;
}

void _playbackInfoSerialize(
  PlaybackInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.lastPositionMs);
  writer.writeString(offsets[1], object.lastSongArtist);
  writer.writeLong(offsets[2], object.lastSongAudioId);
  writer.writeString(offsets[3], object.lastSongTitle);
  writer.writeString(offsets[4], object.lastSongUri);
  writer.writeString(offsets[5], object.repeatMode);
  writer.writeBool(offsets[6], object.shuffleEnabled);
}

PlaybackInfo _playbackInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaybackInfo(
    lastPositionMs: reader.readLongOrNull(offsets[0]),
    lastSongArtist: reader.readStringOrNull(offsets[1]),
    lastSongAudioId: reader.readLongOrNull(offsets[2]),
    lastSongTitle: reader.readStringOrNull(offsets[3]),
    lastSongUri: reader.readStringOrNull(offsets[4]),
    repeatMode: reader.readStringOrNull(offsets[5]) ?? 'none',
    shuffleEnabled: reader.readBoolOrNull(offsets[6]) ?? false,
  );
  object.id = id;
  return object;
}

P _playbackInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? 'none') as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playbackInfoGetId(PlaybackInfo object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playbackInfoGetLinks(PlaybackInfo object) {
  return [];
}

void _playbackInfoAttach(
  IsarCollection<dynamic> col,
  Id id,
  PlaybackInfo object,
) {
  object.id = id;
}

extension PlaybackInfoQueryWhereSort
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QWhere> {
  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlaybackInfoQueryWhere
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QWhereClause> {
  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PlaybackInfoQueryFilter
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QFilterCondition> {
  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastPositionMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPositionMs'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastPositionMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPositionMs'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastPositionMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPositionMs', value: value),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastPositionMsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPositionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastPositionMsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPositionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastPositionMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPositionMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSongArtist'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSongArtist'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastSongArtist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSongArtist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSongArtist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSongArtist',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastSongArtist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastSongArtist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastSongArtist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastSongArtist',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSongArtist', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongArtistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastSongArtist', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongAudioIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSongAudioId'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongAudioIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSongAudioId'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongAudioIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSongAudioId', value: value),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongAudioIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSongAudioId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongAudioIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSongAudioId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongAudioIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSongAudioId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSongTitle'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSongTitle'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastSongTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSongTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSongTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSongTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastSongTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastSongTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastSongTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastSongTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSongTitle', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastSongTitle', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSongUri'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSongUri'),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastSongUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSongUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSongUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSongUri',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastSongUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastSongUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastSongUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastSongUri',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSongUri', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  lastSongUriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastSongUri', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'repeatMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'repeatMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'repeatMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'repeatMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'repeatMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'repeatMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'repeatMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'repeatMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'repeatMode', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  repeatModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'repeatMode', value: ''),
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterFilterCondition>
  shuffleEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shuffleEnabled', value: value),
      );
    });
  }
}

extension PlaybackInfoQueryObject
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QFilterCondition> {}

extension PlaybackInfoQueryLinks
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QFilterCondition> {}

extension PlaybackInfoQuerySortBy
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QSortBy> {
  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPositionMs', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPositionMs', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastSongArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongArtist', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastSongArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongArtist', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastSongAudioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongAudioId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastSongAudioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongAudioId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> sortByLastSongTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongTitle', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastSongTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongTitle', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> sortByLastSongUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongUri', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByLastSongUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongUri', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> sortByRepeatMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByRepeatModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByShuffleEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  sortByShuffleEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.desc);
    });
  }
}

extension PlaybackInfoQuerySortThenBy
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QSortThenBy> {
  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPositionMs', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPositionMs', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastSongArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongArtist', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastSongArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongArtist', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastSongAudioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongAudioId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastSongAudioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongAudioId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> thenByLastSongTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongTitle', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastSongTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongTitle', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> thenByLastSongUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongUri', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByLastSongUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSongUri', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy> thenByRepeatMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByRepeatModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.desc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByShuffleEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.asc);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QAfterSortBy>
  thenByShuffleEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.desc);
    });
  }
}

extension PlaybackInfoQueryWhereDistinct
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct> {
  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct>
  distinctByLastPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPositionMs');
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct> distinctByLastSongArtist({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastSongArtist',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct>
  distinctByLastSongAudioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSongAudioId');
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct> distinctByLastSongTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastSongTitle',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct> distinctByLastSongUri({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSongUri', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct> distinctByRepeatMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackInfo, PlaybackInfo, QDistinct>
  distinctByShuffleEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shuffleEnabled');
    });
  }
}

extension PlaybackInfoQueryProperty
    on QueryBuilder<PlaybackInfo, PlaybackInfo, QQueryProperty> {
  QueryBuilder<PlaybackInfo, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaybackInfo, int?, QQueryOperations> lastPositionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPositionMs');
    });
  }

  QueryBuilder<PlaybackInfo, String?, QQueryOperations>
  lastSongArtistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSongArtist');
    });
  }

  QueryBuilder<PlaybackInfo, int?, QQueryOperations> lastSongAudioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSongAudioId');
    });
  }

  QueryBuilder<PlaybackInfo, String?, QQueryOperations>
  lastSongTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSongTitle');
    });
  }

  QueryBuilder<PlaybackInfo, String?, QQueryOperations> lastSongUriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSongUri');
    });
  }

  QueryBuilder<PlaybackInfo, String, QQueryOperations> repeatModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatMode');
    });
  }

  QueryBuilder<PlaybackInfo, bool, QQueryOperations> shuffleEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shuffleEnabled');
    });
  }
}
