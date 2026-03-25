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

class PaginationModel2<T> {
  final List<T> userData;
  final int currentPage;
  //how any pages are there
  final int pageCount;
  final bool hasNextPage;

  PaginationModel2({
    required this.userData,
    required this.currentPage,
    required this.pageCount,
    required this.hasNextPage,
  });
}
