import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'listing.dart';
import '../locations/location.dart';

int _selectedLocation = 0;

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController titleController = TextEditingController();
  double price = 0;
  String description = '';

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('listings');
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text('Create listing'),
            trailing: GestureDetector(
                onTap: () {
                  if (titleController.text.isEmpty) {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text('Empty title'),
                            content: const Text('Title cannot be empty'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Ok'),
                              )
                            ]
                          );
                        }
                    );
                  } else {
                    Listing l = Listing(
                        title: titleController.text.trim(),
                        time: DateTime.now(),
                        price: price,
                        location: _selectedLocation,
                        description: description.trim(),
                        uid: uid
                    );
                    items.add(l.toFirestore());
                    Navigator.pushReplacementNamed(context, 'listings');
                    _selectedLocation = 0;
                  }
                },
                child: const Icon(CupertinoIcons.checkmark))),
        child: ListView(children: [
          CupertinoFormSection(margin: const EdgeInsets.all(12), children: [
            CupertinoTextFormFieldRow(
              placeholder: 'Title',
              controller: titleController,
            ),
            CupertinoTextFormFieldRow(
                placeholder: 'Price - empty for free',
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (value) {
                  price = double.parse(value);
                }
              ),
            CupertinoTextFormFieldRow(
                placeholder: 'Description',
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 10,
                onChanged: (value) {
                  description = value;
                },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[Text('Location: '), LocationPicker()],
            )
          ])
        ]));
  }
}

// Temporarily here to pass location info
class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final double _kItemExtent = 32.0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 250,
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
            onSelectedItemChanged: (int location) {
              setState(() {
                _selectedLocation = location;
              });
            },
            children: List<Widget>.generate(Location.count, (int index) {
              return Center(child: Text(Location.values[index].locationName));
            })),
      ),
      child: Text(Location.values[_selectedLocation].locationName),
    );
  }
}
