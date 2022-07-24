import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'listing.dart';
import '../locations/location.dart';
import 'dart:io';

import 'listinghelper.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController titleController = TextEditingController();
  num price = 0;
  final TextEditingController descController = TextEditingController();
  int _selectedLocation = 0;
  bool setStateCalled = false;

  //For firebase storage of MULTIPLE images
  List<String> imageNameArr = ['',''];
  List imagePathArr = ['','']; 
  List uploadPathList = []; 
  final multipicker = ImagePicker();
  List<XFile> images = [];

  //For firebase storage of SINGLE images
  // String imageName = '';
  // XFile? imagePath;
  final Reference storageRef = FirebaseStorage.instance.ref().child('Image');
  bool _isLoading = false;

  @override
  void deactivate() {
    titleController.dispose();
    descController.dispose();
    _selectedLocation = 0;
    _isLoading = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('search_listings');
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    var lHelper = ModalRoute.of(context)?.settings.arguments;
    Listing? listing;
    if (lHelper != null) {
      final helper = lHelper as ListingHelper;
      listing = helper.listing;

      if (!setStateCalled) {
        setStateCalled = true;
        titleController.text = listing.title;
        price = listing.price;
        descController.text = listing.description ?? '';
        _selectedLocation = listing.location;
      }
    }

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
            middle: Text('${listing != null ? 'Edit' : 'Create'} listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily), textScaleFactor: 1),
            trailing: GestureDetector(
                key: const Key('create button'),
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
                                key: const Key('empty title create'),
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
                  } else if (listing == null) {
                    // new listing
                    if (images.isEmpty) {
                      // no image uploaded
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                  'No image',
                                  style: TextStyle(
                                      fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                  )
                              ),
                              content: Text(
                                  'Please select at least 1 image',
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
                              ],
                            );
                          }
                      );
                    } else {
                      // image present, create new listing
                      setState(() {
                        _isLoading = true;
                      });

                      void completer() async {
                        var urls = await uploadToStorageGetUrls(images);

                        if (listing == null) {
                          Listing l = Listing(
                          title: titleController.text.trim(),
                          time: DateTime.now(),
                          price: price,
                          location: _selectedLocation,
                          description: descController.text.trim(),
                          uid: uid,
                          imageURL: urls
                        );

                        items.add(l.toFirestore());

                        if (mounted) {
                          // ok to pushReplacementNamed here since listings doesn't allow popping
                          Navigator.pushReplacementNamed(context, 'listings');
                        }
                        }  
                      }
                      completer();
                    }
                  } else {
                    // modify an existing listing
                    setState(() {
                      _isLoading = true;
                    });

                    if (images.isNotEmpty) {
                      // also update listing image
                      uploadToStorageGetUrls(images).then((urls) {
                        Listing l = listing as Listing;
                        l.update(
                            title: titleController.text.trim(),
                            price: price,
                            location: _selectedLocation,
                            description: descController.text.trim(),
                            imageURL: urls
                        );
                        if (mounted) {
                          // not ok to pushReplacementNamed here as it will allow popping to old listing page with old details
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              'indiv',
                              ModalRoute.withName('home'),
                              arguments: lHelper
                          );
                        }
                      });
                    } else {
                      // no need to update listing image
                      lHelper as ListingHelper;
                      lHelper.listing.update(
                          title: titleController.text.trim(),
                          price: price,
                          location: _selectedLocation,
                          description: descController.text.trim(),
                      );
                      if (mounted) {
                        // not ok to pushReplacementNamed here as it will allow popping to old listing page with old details
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            'indiv',
                            ModalRoute.withName('home'),
                            arguments: lHelper
                        );
                      }
                    }
                  }
                },
                child: const Icon(CupertinoIcons.checkmark))),
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
            children: [
                CupertinoFormSection.insetGrouped(
                    header: Text('Images'.toUpperCase()),
                    footer: Wrap(
                        spacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.info, size: 16, color:CupertinoColors.secondaryLabel),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: images.length == 2 || (lHelper != null && listing!.imageURL.length == 2) ? const Text('Tap on the second picture to select again.') : const Text('Select up to 2 images.'),
                          )
                        ]
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                  decoration: const BoxDecoration(border: Border(right: BorderSide(width: 0.3, color: CupertinoColors.separator))),
                                  child: images.isNotEmpty
                                      ? AspectRatio(aspectRatio: 1, child: Image.file(File(images[0].path)))
                                      : lHelper != null
                                      ? listing!.showImage(square: false, ind: 0)
                                      : CupertinoButton(
                                          onPressed: () {
                                            getMultiImages();
                                          },
                                          child: const Icon(CupertinoIcons.add),
                                        ),
                              ),
                            ),
                          ),
                          Flexible(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: images.isEmpty && lHelper == null
                                  ? Container()
                                  : CupertinoButton(
                                      onPressed: () {
                                        getMultiImages();
                                      },
                                      child: images.length == 2
                                          ? Image.file(File(images[1].path))
                                          : images.length == 1 || (lHelper != null && listing!.imageURL.length == 1)
                                          ? const Icon(CupertinoIcons.add)
                                          : listing!.showImage(square: false, ind: 1)
                                )
                              )
                          )
                        ],
                      )
                    ]
                ),
                CupertinoFormSection.insetGrouped(
                    header: Text('Details'.toUpperCase()),
                    children: [
                      CupertinoTextFormFieldRow(
                        key: const Key('create title'),
                        placeholder: 'Title',
                        controller: titleController,
                      ),
                      CupertinoTextFormFieldRow(
                        key: const Key('create price'),
                        placeholder: 'Price - empty for free',
                        initialValue: listing == null ? null : price.toStringAsFixed(2),
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                        ],
                        onChanged: (value) {
                          price = double.parse(value);
                        }
                      ),
                      CupertinoTextFormFieldRow(
                        key: const Key('create description'),
                        placeholder: 'Description',
                        controller: descController,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 26, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Location'),
                            PullDownButton(
                                position: PullDownMenuPosition.under,
                                itemBuilder: (context) {
                                  return Location.values
                                      .map((loc) => PullDownMenuItem(
                                      title: loc.fullName,
                                      textStyle: TextStyle(
                                          color: CupertinoColors.black,
                                          fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily,
                                      ),
                                      onTap: () {
                                        _selectedLocation = loc.index;
                                      })
                                  ).toList();
                                },
                                buttonBuilder: (context, showMenu) {
                                  return Container(
                                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                                      child: CupertinoButton(
                                        minSize: 32,
                                        color: CupertinoColors.tertiarySystemFill,
                                        onPressed: showMenu,
                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(
                                            Location.values[_selectedLocation].fullName,
                                            style: const TextStyle(color: CupertinoColors.black)
                                        )
                                    )
                                  );
                                }
                            )
                          ],
                        )
                      )
                ])
        ])
    );
  }

  //Tools for multi imaging
  Future getMultiImages() async {
    final List<XFile>? selectedImages = await multipicker.pickMultiImage();
    setState(() {
      if (selectedImages != null && selectedImages.isNotEmpty) {
        images = selectedImages.take(2).toList();
      }
    });
  }

  Future<List<String>> uploadToStorageGetUrls(List<XFile> images) async {
    var imageUrls = await Future.wait(images.map((image) => uploadFile(image)));
    return imageUrls;
  }

  Future<String> uploadFile(XFile image) async {
    String uploadFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference reference = storageRef.child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(image.path));
    await uploadTask.whenComplete(() {});
    return await reference.getDownloadURL();
  }

  // //Gallery and camera pickers
  // imagePicker () async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if(image != null) {
  //     setState(() {
  //       imagePath = image;
  //       imageName = image.name.toString();
  //     });
  //   }
  // }
  //
  // cameraPicker () async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if(image != null) {
  //     setState(() {
  //       imagePath = image;
  //       imageName = image.name.toString();
  //     });
  //   }
  // }

  // //Widget for selection of camera/ upload from gallery
  // Widget buildActionSheet(BuildContext context) => CupertinoActionSheet(
  //   actions: [
  //     CupertinoActionSheetAction(
  //       onPressed: () {
  //         imagePicker();
  //         Navigator.pop(context, 'Cancel');
  //       },
  //       child: Text('Gallery', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
  //     ),
  //     CupertinoActionSheetAction(
  //       onPressed: () {
  //         cameraPicker();
  //         Navigator.pop(context, 'Cancel');
  //       },
  //       child: Text('Take a photo', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
  //     )
  //   ],
  //   cancelButton: CupertinoActionSheetAction(
  //     onPressed: () {
  //       Navigator.pop(context, 'Cancel');
  //     },
  //     child: Text('Cancel', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
  //   ),
  // );
}

