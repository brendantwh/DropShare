import 'package:flutter/material.dart';
import '../locations/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  int _selectedLocation = 0; 

  RangeValues values = RangeValues(0,500);
  RangeLabels labels = RangeLabels('0', '500');

  @override
  void deactivate() {
    _selectedLocation = 0;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
            middle: Text('Filter', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
            trailing: Wrap(spacing: 10, children: <Widget>[
              GestureDetector(
                onTap: () {
                  showCupertinoDialog(context: context, builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Filter applied'),
                      content: const Text('Filters will be applied to your searched listings from now on.'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, 'search', arguments: [_selectedLocation, values], ModalRoute.withName('listings'));
                          },
                          child: Text('Ok', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                    )]);
                  });
                },
                child: const Icon(CupertinoIcons.checkmark),
              ), 
            ]),
      ),
      child: ListView(
        children: [
          CupertinoFormSection(
            margin: const EdgeInsets.all(12),
            children: [

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
                              title: loc.locationName,
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
                                    Location.values[_selectedLocation].locationName,
                                    style: const TextStyle(color: CupertinoColors.black)
                                )
                            )
                          );
                        }
                    )
                  ],
                )
              ),
              
              Container(
                padding: const EdgeInsets.only(left: 26, right: 20),
                child: Material(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Price Range'),
                    Flexible(
                      child: RangeSlider(
                      min: 0,
                      max: 500,
                      values: values,
                      divisions: 50,
                      labels: labels,
                      onChanged: (value) {
                        setState(() {
                          values = value;
                          labels = RangeLabels('\$${value.start.toInt().toString()}','\$${value.end.toInt().toString()}');
                        });
                      }))
                ],))
              ),
          ]),
          Container(
            padding: const EdgeInsets.only(left: 26, right: 20),
            child: CupertinoButton(
              child: const Text('Remove Filter', style: TextStyle(color: CupertinoColors.destructiveRed),), 
              onPressed: () {
                showCupertinoDialog(context: context, builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Filter removed'),
                      content: const Text('Filters will not be applied to your searched listings from now on.'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, 'search', ModalRoute.withName('listings'));
                          },
                          child: Text('Ok', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                    )]);
                  });
              }
            )
          )
        ],
      )
    );
  }
}
