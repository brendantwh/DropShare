import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'listing.dart';
import '../locations/location.dart';
import 'dart:io';

int _selectedLocation = 0;

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController _titleController = TextEditingController();
  double price = 0;
  String description = '';

  //For firebase storage of images
  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  FirebaseStorage storageRef = FirebaseStorage.instance;
  String collectionName = 'Image';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('listings');

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text('Create listing'),
            trailing: GestureDetector(
                onTap: () {
                  if (_titleController.text.isEmpty) {
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
                  } else if (imageName.isEmpty) {
                    showCupertinoDialog(
                      context: context, 
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('No image'),
                          content: const Text('Please select at least 1 image'),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Ok'),
                            )
                          ],
                        );
                      }
                    );
                  } else {
                    //Upload image to storage and get url to upload to firestore
                    setState(() {
                      _isLoading = true;
                    });
                    String uploadFileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
                    Reference reference = storageRef.ref().child(collectionName).child(uploadFileName);
                    UploadTask uploadTask = reference.putFile(File(imagePath!.path));

                    uploadTask.snapshotEvents.listen((event) {
                      print(event.bytesTransferred.toString() + "\t" + event.totalBytes.toString());
                    });

                    uploadTask.whenComplete(() async {
                      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
                      Listing l = Listing(
                        title: _titleController.text,
                        time: DateTime.now(),
                        price: price,
                        location: _selectedLocation,
                        description: description,
                        imageURL: uploadPath,
                        reported: false);
                      items.add(l.toFirestore());
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pushReplacementNamed(context, 'listings');
                      _selectedLocation = 0;
                      });
                    }
                },
                child: const Icon(CupertinoIcons.checkmark))),
        child: _isLoading
            ? Center(child: CupertinoActivityIndicator())
            : ListView(children: [CupertinoFormSection(margin: const EdgeInsets.all(12), children: [
              CupertinoTextFormFieldRow(
                placeholder: 'Title',
                controller: _titleController,
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
              ),
              imageName == "" ? Container() : Text("${imageName}"),
              CupertinoButton(
                child: const Text('Select image'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context, 
                    builder: buildActionSheet,
                  );
                },
              )
            ])
          ]));
  }

  //Gallery and camera pickers
  imagePicker () async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }

  cameraPicker () async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if(image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }

  //Widget for selection of camera/ upload from gallery
  Widget buildActionSheet(BuildContext context) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        onPressed: () {
          imagePicker();
          Navigator.pop(context, 'Cancel');
        },
        child: Text('All Photos')
      ),
      CupertinoActionSheetAction(
        onPressed: () {
          cameraPicker();
          Navigator.pop(context, 'Cancel');
        }, 
        child: Text('New Photo')
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      }, 
      child: Text('Cancel')
    ),
  );
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
