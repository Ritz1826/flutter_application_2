class PaginationModel<T> {
  final List<T> userData;
  final int limit;
  final int skip;
  final bool hasNextPage;

  PaginationModel({
    required this.userData,
    required this.limit,
    required this.skip,
    required this.hasNextPage,
  });
}
