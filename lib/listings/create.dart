import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController titleController = TextEditingController();
  num price = 0;
  final TextEditingController descController = TextEditingController();

  //For firebase storage of images
  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  FirebaseStorage storageRef = FirebaseStorage.instance;
  String collectionName = 'Image';
  bool _isLoading = false;

  @override
  void deactivate() {
    titleController.dispose();
    descController.dispose();
    _selectedLocation = 0;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('listings');
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    var listing = ModalRoute.of(context)?.settings.arguments;
    if (listing != null) {
      listing = listing as Listing;
      titleController.text = listing.title;
      price = listing.price;
      descController.text = listing.description ?? '';
      _selectedLocation = listing.location;
    }

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
                            title: Text(
                                'Empty title',
                                style: TextStyle(
                                    fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                )
                            ),
                            content: Text(
                                'Title cannot be empty',
                                style: TextStyle(
                                    fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                )
                            ),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                    'Ok',
                                    style: TextStyle(
                                        fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                    )
                                ),
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
                      if (listing == null) {
                        // create a new listing
                        Listing l = Listing(
                            title: titleController.text.trim(),
                            time: DateTime.now(),
                            price: price,
                            location: _selectedLocation,
                            description: descController.text.trim(),
                            uid: uid,
                            imageURL: uploadPath
                        );
                        items.add(l.toFirestore());
                        setState(() {
                          _isLoading = false;
                        });
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, 'listings');
                        }
                      } else {
                        // modify an existing listing
                        Listing l = listing as Listing;
                        l.update(
                            title: titleController.text.trim(),
                            price: price,
                            location: _selectedLocation,
                            description: descController.text.trim(),
                            imageURL: uploadPath);
                        setState(() {
                          _isLoading = false;
                        });
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, 'indiv', arguments: l);
                        }
                      }
                      });
                    }
                  },
                child: const Icon(CupertinoIcons.checkmark))),
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(children: [
                CupertinoFormSection(
                    margin: const EdgeInsets.all(12),
                    children: [
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
                        controller: descController,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Location: '),
                          LocationPicker()
                        ],
                      ),
                      imageName == ""
                          ? Container()
                          : Text(imageName),
                      CupertinoButton(
                        child: const Text('Select image'),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: buildActionSheet,
                          );
                        }
                      )
                ])
        ])
    );
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
        child: const Text('Gallery')
      ),
      CupertinoActionSheetAction(
        onPressed: () {
          cameraPicker();
          Navigator.pop(context, 'Cancel');
        },
        child: const Text('Take a photo')
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
      child: const Text('Cancel')
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
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showDialog(
        CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: _selectedLocation),
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
