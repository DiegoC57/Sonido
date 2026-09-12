// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_play.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentPlayCollection on Isar {
  IsarCollection<RecentPlay> get recentPlays => this.collection();
}

const RecentPlaySchema = CollectionSchema(
  name: r'RecentPlay',
  id: -3942032969661981305,
  properties: {
    r'albumKey': PropertySchema(
      id: 0,
      name: r'albumKey',
      type: IsarType.string,
    ),
    r'albumName': PropertySchema(
      id: 1,
      name: r'albumName',
      type: IsarType.string,
    ),
    r'artistName': PropertySchema(
      id: 2,
      name: r'artistName',
      type: IsarType.string,
    ),
    r'playedAt': PropertySchema(
      id: 3,
      name: r'playedAt',
      type: IsarType.dateTime,
    ),
    r'representativeAudioId': PropertySchema(
      id: 4,
      name: r'representativeAudioId',
      type: IsarType.long,
    ),
  },

  estimateSize: _recentPlayEstimateSize,
  serialize: _recentPlaySerialize,
  deserialize: _recentPlayDeserialize,
  deserializeProp: _recentPlayDeserializeProp,
  idName: r'id',
  indexes: {
    r'albumKey': IndexSchema(
      id: 8512154875591279857,
      name: r'albumKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'albumKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _recentPlayGetId,
  getLinks: _recentPlayGetLinks,
  attach: _recentPlayAttach,
  version: '3.3.2',
);

int _recentPlayEstimateSize(
  RecentPlay object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumKey.length * 3;
  {
    final value = object.albumName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.artistName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _recentPlaySerialize(
  RecentPlay object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumKey);
  writer.writeString(offsets[1], object.albumName);
  writer.writeString(offsets[2], object.artistName);
  writer.writeDateTime(offsets[3], object.playedAt);
  writer.writeLong(offsets[4], object.representativeAudioId);
}

RecentPlay _recentPlayDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentPlay(
    albumKey: reader.readString(offsets[0]),
    albumName: reader.readStringOrNull(offsets[1]),
    artistName: reader.readStringOrNull(offsets[2]),
    playedAt: reader.readDateTime(offsets[3]),
    representativeAudioId: reader.readLongOrNull(offsets[4]),
  );
  object.id = id;
  return object;
}

P _recentPlayDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentPlayGetId(RecentPlay object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentPlayGetLinks(RecentPlay object) {
  return [];
}

void _recentPlayAttach(IsarCollection<dynamic> col, Id id, RecentPlay object) {
  object.id = id;
}

extension RecentPlayByIndex on IsarCollection<RecentPlay> {
  Future<RecentPlay?> getByAlbumKey(String albumKey) {
    return getByIndex(r'albumKey', [albumKey]);
  }

  RecentPlay? getByAlbumKeySync(String albumKey) {
    return getByIndexSync(r'albumKey', [albumKey]);
  }

  Future<bool> deleteByAlbumKey(String albumKey) {
    return deleteByIndex(r'albumKey', [albumKey]);
  }

  bool deleteByAlbumKeySync(String albumKey) {
    return deleteByIndexSync(r'albumKey', [albumKey]);
  }

  Future<List<RecentPlay?>> getAllByAlbumKey(List<String> albumKeyValues) {
    final values = albumKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'albumKey', values);
  }

  List<RecentPlay?> getAllByAlbumKeySync(List<String> albumKeyValues) {
    final values = albumKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'albumKey', values);
  }

  Future<int> deleteAllByAlbumKey(List<String> albumKeyValues) {
    final values = albumKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'albumKey', values);
  }

  int deleteAllByAlbumKeySync(List<String> albumKeyValues) {
    final values = albumKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'albumKey', values);
  }

  Future<Id> putByAlbumKey(RecentPlay object) {
    return putByIndex(r'albumKey', object);
  }

  Id putByAlbumKeySync(RecentPlay object, {bool saveLinks = true}) {
    return putByIndexSync(r'albumKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAlbumKey(List<RecentPlay> objects) {
    return putAllByIndex(r'albumKey', objects);
  }

  List<Id> putAllByAlbumKeySync(
    List<RecentPlay> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'albumKey', objects, saveLinks: saveLinks);
  }
}

extension RecentPlayQueryWhereSort
    on QueryBuilder<RecentPlay, RecentPlay, QWhere> {
  QueryBuilder<RecentPlay, RecentPlay, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentPlayQueryWhere
    on QueryBuilder<RecentPlay, RecentPlay, QWhereClause> {
  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> idBetween(
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

  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> albumKeyEqualTo(
    String albumKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'albumKey', value: [albumKey]),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterWhereClause> albumKeyNotEqualTo(
    String albumKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'albumKey',
                lower: [],
                upper: [albumKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'albumKey',
                lower: [albumKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'albumKey',
                lower: [albumKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'albumKey',
                lower: [],
                upper: [albumKey],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension RecentPlayQueryFilter
    on QueryBuilder<RecentPlay, RecentPlay, QFilterCondition> {
  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'albumKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'albumKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'albumKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'albumKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'albumKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'albumKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'albumKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'albumKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'albumKey', value: ''),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'albumKey', value: ''),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'albumName'),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'albumName'),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'albumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'albumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'albumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'albumName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'albumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'albumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'albumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> albumNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'albumName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'albumName', value: ''),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  albumNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'albumName', value: ''),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'artistName'),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'artistName'),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> artistNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'artistName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'artistName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'artistName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> artistNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'artistName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'artistName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'artistName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'artistName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> artistNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'artistName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'artistName', value: ''),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  artistNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'artistName', value: ''),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> playedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playedAt', value: value),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  playedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> playedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition> playedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  representativeAudioIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'representativeAudioId'),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  representativeAudioIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'representativeAudioId'),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  representativeAudioIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'representativeAudioId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  representativeAudioIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'representativeAudioId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  representativeAudioIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'representativeAudioId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterFilterCondition>
  representativeAudioIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'representativeAudioId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RecentPlayQueryObject
    on QueryBuilder<RecentPlay, RecentPlay, QFilterCondition> {}

extension RecentPlayQueryLinks
    on QueryBuilder<RecentPlay, RecentPlay, QFilterCondition> {}

extension RecentPlayQuerySortBy
    on QueryBuilder<RecentPlay, RecentPlay, QSortBy> {
  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByAlbumKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumKey', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByAlbumKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumKey', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByAlbumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByAlbumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByArtistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByArtistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> sortByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy>
  sortByRepresentativeAudioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeAudioId', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy>
  sortByRepresentativeAudioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeAudioId', Sort.desc);
    });
  }
}

extension RecentPlayQuerySortThenBy
    on QueryBuilder<RecentPlay, RecentPlay, QSortThenBy> {
  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByAlbumKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumKey', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByAlbumKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumKey', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByAlbumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByAlbumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByArtistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByArtistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy> thenByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy>
  thenByRepresentativeAudioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeAudioId', Sort.asc);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QAfterSortBy>
  thenByRepresentativeAudioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeAudioId', Sort.desc);
    });
  }
}

extension RecentPlayQueryWhereDistinct
    on QueryBuilder<RecentPlay, RecentPlay, QDistinct> {
  QueryBuilder<RecentPlay, RecentPlay, QDistinct> distinctByAlbumKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QDistinct> distinctByAlbumName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QDistinct> distinctByArtistName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QDistinct> distinctByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playedAt');
    });
  }

  QueryBuilder<RecentPlay, RecentPlay, QDistinct>
  distinctByRepresentativeAudioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'representativeAudioId');
    });
  }
}

extension RecentPlayQueryProperty
    on QueryBuilder<RecentPlay, RecentPlay, QQueryProperty> {
  QueryBuilder<RecentPlay, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentPlay, String, QQueryOperations> albumKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumKey');
    });
  }

  QueryBuilder<RecentPlay, String?, QQueryOperations> albumNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumName');
    });
  }

  QueryBuilder<RecentPlay, String?, QQueryOperations> artistNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistName');
    });
  }

  QueryBuilder<RecentPlay, DateTime, QQueryOperations> playedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playedAt');
    });
  }

  QueryBuilder<RecentPlay, int?, QQueryOperations>
  representativeAudioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'representativeAudioId');
    });
  }
}
