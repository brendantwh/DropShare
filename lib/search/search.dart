import 'package:typesense/typesense.dart';

class Search {
  // Typesense API keys
  static const String _adminApiKey = 'sRnOqwKCth0R1UAg2rOKov03tnbD3jSc';
  static const String _allSearchApiKey = '0XDCb1O7bIXC2wwzQz16s7br2em6a6an';
  static const String _allSearchApiKeyAllCol = 'H9m6gDxOYNe6jPNaQt0agd8hKIV0A7W7';

  // Typesense server
  static const String _host = 'search.dropshare.tk';
  static const int _port = 443;
  static const Protocol _protocol = Protocol.https;

  // Typesense configurations
  static final Configuration _adminConfig = Configuration(
      _adminApiKey,
      nodes: {
        Node(
          _protocol,
          _host,
          port: _port,
        )
      },
      numRetries: 3,
      connectionTimeout: const Duration(seconds: 3)
  );
  static final Configuration _userSearchConfig = Configuration(
      _allSearchApiKey,
      nodes: {
        Node(
          _protocol,
          _host,
          port: _port,
        )
      },
      numRetries: 3,
      connectionTimeout: const Duration(seconds: 3)
  );
  static final Configuration _userSearchAllConfig = Configuration(
      _allSearchApiKeyAllCol,
      nodes: {
        Node(
          _protocol,
          _host,
          port: _port,
        )
      },
      numRetries: 3,
      connectionTimeout: const Duration(seconds: 3)
  );

  // Typesense clients
  static final adminClient = Client(_adminConfig);
  static final userSearchClient = Client(_userSearchConfig);
  static final userSearchAllClient = Client(_userSearchAllConfig);

  // Schema for Typesense collection
  static var listingSchema = Schema(
      'search_listings',
      {
        Field('title', Type.string),
        Field('time', Type.int64),
        Field('price', Type.float),
        Field('location', Type.int32),
        Field('description', Type.string),
        Field('uid', Type.string),
        Field('visible', Type.bool),
        Field('sold', Type.bool),
        Field('imageURL', Type.string),
        Field('reported', Type.bool)
      }
  );
}