enum Location {
  Eusoff,
  Kent_Ridge,
  KE_VII,
  Raffles,
  Sheares,
  Temasek,
  PGP,
  RVRC,
  CAPT,
  RC4,
  Tembusu,
  NUSC,
  UTR;

  static int get count {
    return 13;
  }

  String get shortName {
    return name.replaceAll(RegExp('[\\W_]+'),' ');
  }
}

extension LocationLong on Location {
  String get fullName {
    switch (this) {
      case Location.Eusoff:
        return 'Eusoff';
      case Location.Kent_Ridge:
        return 'Kent Ridge';
      case Location.KE_VII:
        return 'King Edward VII';
      case Location.Raffles:
        return 'Raffles';
      case Location.Sheares:
        return 'Sheares';
      case Location.Temasek:
        return 'Temasek';
      case Location.PGP:
        return 'Prince George\'s Park';
      case Location.RVRC:
        return 'Ridge View RC';
      case Location.CAPT:
        return 'CAPT';
      case Location.RC4:
        return 'RC4';
      case Location.Tembusu:
        return 'Tembusu';
      case Location.NUSC:
        return 'NUS College';
      case Location.UTR:
        return 'UTown Residences';
    }
  }
}