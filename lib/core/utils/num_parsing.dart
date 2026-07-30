/// Parses a JSON numeric field that may arrive as a native `num` or as a
/// `String` — some backend ORMs (e.g. Prisma's `Decimal` type) serialize
/// money/decimal columns as strings rather than JSON numbers. Every
/// backend-mode datasource/repository should read amounts through this
/// instead of a blind `as num` cast.
double? parseNumOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Same as [parseNumOrNull] but defaults to 0 when missing/unparseable.
double parseNum(dynamic value) => parseNumOrNull(value) ?? 0;
