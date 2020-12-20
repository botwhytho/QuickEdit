# QuickEdit

A tool to quickly modify the values of nested Arrays/Dictionaries in [Glamorous Toolkit](https://gtoolkit.com/).

- Currently only supporting updating of values.
- This is geared towards manually modifying JSON data so it's only meant to be used on Arrays/Dictionaries that have Booleans, Numbers, nil or Strings as the nested values.

# Installation

```Smalltalk
Metacello new
    baseline: 'QuickEdit';
    repository: 'github://botwhytho/quick-edit:main/src';
    load ].
```

# Using

To use, simple send `quickedit` to an Array or Dictionary and inspect the output. You will be able to edit the nested values on the second column of the `Edit` view that comes up. Double click a value to gain editable focus. Once `Enter` is pressed your changes will propagate to the underlying objects; if you want to abort a change, press `Esc`. Running something like the snippet below should give you an idea of the tool's functionality.

```Smalltalk
(NeoJSONReader fromString: (ZnClient new get: 'https://httpbin.org/json')) quickedit
```
