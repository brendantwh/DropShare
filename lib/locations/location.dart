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

  String get locationName {
    return name.replaceAll(RegExp('[\\W_]+'),' ');
  }
}