class UrlMatcher {
  const UrlMatcher({
    String endpoint = '.*',
    List<String> queries = const [],
  })  : _endpoint = endpoint,
        _queries = queries;

  factory UrlMatcher.fromJson(Map<String, dynamic> json) {
    final List<dynamic> queries = json['queries'];
    return UrlMatcher(
      endpoint: json['endpoint'],
      queries: queries.cast<String>(),
    );
  }

  final String _endpoint;
  final List<String> _queries;

  UrlMatcher endpoint(String endpoint) {
    assert(endpoint != null);
    assert(!endpoint.endsWith('?'), 'Don\'t append ? to end of the endpoint');
    return _copyWith(endpoint: endpoint);
  }

  UrlMatcher page(int page) {
    return page != null ? withQuery('page=$page') : this;
  }

  UrlMatcher withQuery(String query) {
    assert(query != null);
    assert(
      query.contains(RegExp(r'^[a-z_-]+=[a-z0-9_-]+$')),
      'A query param should follow a "key=value" pattern',
    );
    return _copyWith(queries: [..._queries, query]);
  }

  bool hasMatch(String url) {
    assert(url != null, 'You need to pass url to match');
    assert(_endpoint != null, 'You need to pass endpoint to match');

    if (_queries.isEmpty) {
      return _endpoint == '.*' ||
          url.replaceAll(RegExp(r'(\?.*)'), '').endsWith(_endpoint);
    } else {
      final String regex = _queries.fold(
        _endpoint,
        (prev, query) => '$prev.*((&|\\?)$query)',
      );
      return RegExp(regex).hasMatch(Uri.decodeFull(url));
    }
  }

  UrlMatcher _copyWith({
    String endpoint,
    List<String> queries,
  }) {
    return UrlMatcher(
      endpoint: endpoint ?? _endpoint,
      queries: queries ?? _queries,
    );
  }

  Map<String, dynamic> toJson() => {
        'endpoint': _endpoint,
        'queries': _queries,
      };
}
