### Class naming
Customized wrapper for a default class -> Custom[default_class_name], e.g. `CustomTextField`

Class with unique functionality -> [name], e.g. `DockedDialog`, `SearchField`, `DateSelector`

---
### Route naming
[name]Page, e.g. EntryListPage

[name]Dialog, e.g. NewEntryDialog

page/dialog displays a list of x -> [singular_x]ListPage, e.g. EntryListPage

---
### Method signature
##### General
Method changes value -> setValue

Method retrieves/calculates value -> getValue

Method retrieves a value (Flutter types like Color, Widget, etc.) using conditionals -> resolveValue, e.g. 
`resolveWidgetWrapper()`, `resolveButtonColor()`

Method retrieves a value (Dart types like int, bool, DateTime, etc.) by calculating -> calculateValue, e.g. 
`calculateDatePair()`, `calculateTotalValue()`

##### Internal methods 
[return_value_type] _methodName, e.g `void _setPosition()`

For internal getters return value type usually should not be specified and instead be clear from method name, e.g.
`_getEntries()`

##### Public and/or static methods
For public methods return value type usually should be specified

---
### Imports
Logically separated with newlines, sorted by import length

Order:
1) Flutter modules, e.g. material, intl, provider
2) AppData
3) Logic / services
4) Data models
5) UI modules
6) Utils
7) Routes
