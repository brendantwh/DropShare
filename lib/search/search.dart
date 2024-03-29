import 'package:dropshare/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:typesense/typesense.dart';

class Search {
  // Typesense API keys
  static String _adminApiKey = useEmulator
      ? 'xyz'  // local typesense
      : 'sRnOqwKCth0R1UAg2rOKov03tnbD3jSc';
  static String _allSearchApiKey = useEmulator
      ? '3v4lJOurZDMMvR2htdcY9YrxFpeIuYca'  // local typesense
      : '0XDCb1O7bIXC2wwzQz16s7br2em6a6an';
  static String _allSearchApiKeyAllCol = useEmulator
      ? 'mLokwjLScPIurwxZu7xx3ds1Lgfo4i3a'  // local typesense
      : 'H9m6gDxOYNe6jPNaQt0agd8hKIV0A7W7';

  // Typesense server
  static String _host = useEmulator ? 'localhost' : 'dropshare.mooo.com';
  static int _port = useEmulator ? 8108 : 443;
  static Protocol _protocol = useEmulator ? Protocol.http : Protocol.https;

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
        Field('imageURL', Type.stringify, isOptional: true),
        Field('reported', Type.bool)
      }
  );

  static get domain => _host;

  static get health async {
    Map<String, dynamic> healthData = await adminClient.health.retrieve();
    if (healthData['ok'] == true) {
      return const Icon(CupertinoIcons.checkmark_circle, color: CupertinoColors.systemGreen);
    } else {
      return const Icon(CupertinoIcons.exclamationmark_circle, color: CupertinoColors.systemRed);
    }
  }

  static get docCount async {
    final colDetails = await adminClient.collection('search_listings')
        .retrieve();
    return colDetails.documentCount;
  }
}