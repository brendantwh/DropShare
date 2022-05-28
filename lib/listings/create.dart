import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../locations/locationpicker.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text('Create listing'),
            trailing: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'listings');
                },
                child: const Icon(CupertinoIcons.checkmark))),
        child: ListView(children: [
          CupertinoFormSection(margin: const EdgeInsets.all(12), children: [
            CupertinoTextFormFieldRow(
                placeholder: 'Title',
            ),
            CupertinoTextFormFieldRow(
                placeholder: 'Price',
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ]),
            CupertinoTextFormFieldRow(
                placeholder: 'Description',
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[Text('Location: '), LocationPicker()],
            )
          ])
        ]));
  }
}
