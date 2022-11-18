import 'package:flutter/material.dart';
import 'package:selectable_container/selectable_container.dart';

///Main widget of Parent Child Checkbox.
///Parent Child Checkbox is a type of checkbox where we can establish hierarchy in Checkboxes.
class ParentChildCheckbox extends StatefulWidget {
  ///Text Widget to specify the Parent checkbox
  final Text? parent;

  ///List<Text> Widgets to specify the Children checkboxes
  final List<Text>? children;

  ///Color of Parent CheckBox
  ///
  ///Defaults to [ThemeData.toggleableActiveColor].
  final Color? parentCheckboxColor;

  ///Color of Parent CheckBox
  ///
  ///Defaults to [ThemeData.toggleableActiveColor].
  final Color? childrenCheckboxColor;

  ///Default constructor of ParentChildCheckbox
  ParentChildCheckbox({
    required this.parent,
    required this.children,
    this.parentCheckboxColor,
    this.childrenCheckboxColor,
  });

  /// Map which shows whether particular parent is selected or not.
  ///
  /// Example: {'Parent 1' : true, 'Parent 2' : false} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value will be false for all specified parents
  static Map<String?, bool?> _isParentSelected = {};

  /// Getter to get whether particular parent is selected or not.
  ///
  /// Example: {'Parent 1' : true, 'Parent 2' : false} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value will be false for all specified parents
  static get isParentSelected => _isParentSelected;

  /// Map which shows which childrens are selected for a particular parent.
  ///
  /// Example: {'Parent 1' : ['Children 1.1','Children 1.2'], 'Parent 2' : []} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value is {'Parent 1' : [], 'Parent 2' : []}
  static Map<String?, List<String?>> _selectedChildrenMap = {};

  /// Getter to get which childrens are selected for a particular parent.
  ///
  /// Example: {'Parent 1' : ['Children 1.1','Children 1.2'], 'Parent 2' : []} where
  /// Parent 1 and Parent 2 will be 2 separate parents if you are using multiple ParentChildCheckbox in your code.
  ///
  /// Default value is {'Parent 1' : [], 'Parent 2' : []}
  static get selectedChildrens => _selectedChildrenMap;

  @override
  _ParentChildCheckboxState createState() => _ParentChildCheckboxState();
}

class _ParentChildCheckboxState extends State<ParentChildCheckbox> {
  ///Default parentValue set to false
  bool? _parentValue = false;

  ///List of childrenValue which depicts whether checkbox is clicked or not
  List<bool?> _childrenValue = [];

  @override
  void initState() {
    super.initState();
    _childrenValue = List.filled(widget.children!.length, false);
    ParentChildCheckbox._selectedChildrenMap.addAll({widget.parent!.data: []});
    ParentChildCheckbox._isParentSelected.addAll({widget.parent!.data: false});
  }

  @override
  Widget build(BuildContext context) {
    String customText = widget.parent!.data.toString().substring(0, 3);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: _parentValue,
                splashRadius: 0.0,
                activeColor: widget.parentCheckboxColor,
                shape: const CircleBorder(),
                onChanged: (value) => _parentCheckBoxClick(),
                tristate: false,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.10,
              // height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                child: Text(
                  customText.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _parentValue!
                ? Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.children!.length,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Center(
                          child: SelectableContainer(
                              selectedBorderColor: Colors.deepPurple[400],
                              // to make tick icon invisible
                              selectedBackgroundColorIcon: Colors.transparent,
                              selectedBorderColorIcon: Colors.transparent,
                              iconColor: Colors.transparent,
                              //
                              unselectedBorderColor: Colors.grey,
                              selectedBackgroundColor:
                                  Colors.deepPurple.withOpacity(0.2),
                              borderSize: 1,
                              selected: _childrenValue[index]!,
                              onValueChanged: (value) {
                                _childCheckBoxClick(index);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: widget.children![index],
                              )),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text('Unavailable'),
                  )
          ],
        ),
      ],
    );
  }

  ///onClick method when particular children of index i is clicked
  void _childCheckBoxClick(int i) {
    setState(() {
      _childrenValue[i] = !_childrenValue[i]!;
      if (!_childrenValue[i]!) {
        ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
            (value) {
          value.removeWhere((element) => element == widget.children![i].data);
          return value;
        });
      } else {
        ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
            (value) {
          value.add(widget.children![i].data);
          return value;
        });
      }
      //_parentCheckboxUpdate();
    });
  }

  ///onClick method when particular parent is clicked
  void _parentCheckBoxClick() {
    setState(() {
      if (_parentValue != null) {
        _parentValue = !_parentValue!;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => _parentValue);
        ParentChildCheckbox._selectedChildrenMap.addAll({
          widget.parent!.data: [],
        });
        // Not needed by me
        // for (int i = 0; i < widget.children!.length; i++) {
        //_childrenValue[i] = _parentValue;
        // if (_parentValue!) {
        //   ParentChildCheckbox._selectedChildrenMap.update(widget.parent!.data,
        //       (value) {
        //     value.add(widget.children![i].data);
        //     return value;
        //   });
        // }
        // }
      } else {
        _parentValue = false;
        ParentChildCheckbox._isParentSelected
            .update(widget.parent!.data, (value) => _parentValue);
        ParentChildCheckbox._selectedChildrenMap
            .update(widget.parent!.data, (value) => []);
        for (int i = 0; i < widget.children!.length; i++)
          _childrenValue[i] = false;
      }
    });
  }

  // Not using
  ///Method to update the Parent Checkbox based on the status of Child checkbox
  // void _parentCheckboxUpdate() {
  //   setState(() {
  //     if (_childrenValue.contains(false) && _childrenValue.contains(true)) {
  //       _parentValue = true;
  //       ParentChildCheckbox._isParentSelected
  //           .update(widget.parent!.data, (value) => false);
  //     } else {
  //       _parentValue = _childrenValue.first;
  //       ParentChildCheckbox._isParentSelected
  //           .update(widget.parent!.data, (value) => _childrenValue.first);
  //     }
  //   });
  // }
}
