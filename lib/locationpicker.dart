import 'package:flutter/cupertino.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final List<String> _locations = <String>[
    'Eusoff',
    'Kent Ridge',
    'KE VII',
    'Raffles',
    'Sheares',
    'Temasek',
    'PGP',
    'RVRC',
    'CAPT',
    'RC4',
    'Tembusu',
    'NUSC',
    'UTR',
  ];

  final double _kItemExtent = 32.0;
  int _selectedLocation = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showDialog(
              CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: _kItemExtent,
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      _selectedLocation = selectedItem;
                    });
                  },
                  children:
                      List<Widget>.generate(_locations.length, (int index) {
                    return Center(child: Text(_locations[index]));
                  })),
            ),
        child: Text(
          _locations[_selectedLocation],
        ));
  }
}
