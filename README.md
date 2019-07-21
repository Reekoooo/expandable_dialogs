# expandable_dialogs

A new Flutter package for expandable dialogs

## Overview

This package helps to transform any flutter widget into a floating draggable window.

## Usage
First, we need to do add expanded_dialogs to the dependencies of the pubspec.yaml
``` dart
expandable_dialogs: ^ 0.0.3
```

Then you can use it to show your draggable dialog  


``` dart
onPressed: () {
          ExpandableDialog.show(
            context: context,
            child: Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: ExpandableStatus.of(context).isExpanded
                      ? Text("Not Expanded")
                      : Text("Expanded"),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.open_in_new), onPressed: () {})
                  ],
                ),
                body: Container(),
              ),
            ),
           
          );
        },
       
```

## Notes

The expand status of the dialog can be accesses by 

``` dart
ExpandableStatus.of(context).isExpanded
```

Better wrap your widget with a builder so it can provide the proper context to be able to access the isExpanded flag.
 

