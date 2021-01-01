# QuickEdit

A tool to quickly modify the values of an Object's slots or of Collections in [Glamorous Toolkit](https://gtoolkit.com/).

- Currently only supporting updating of values (no adding/removing items from a collection, yet).
- Only values of types Boolean, Number, nil or String will show up as editable.
- Undo functionality works with Ctrl/Cmd + Z or by clicking an undo button that pops up after changes have been made to a value. Undo history only holds a single value at the moment.

# Installation

```Smalltalk
Metacello new
    baseline: 'QuickEdit';
    repository: 'github://botwhytho/quick-edit:main/src';
    load ].
```

# Using

To use, simply inspect an Object or a Collection and you will see new `Edit` & `Items Edit` views respectively where you can modify (and undo) values. Inspect the below snippet in a playground to see the functionality at play. Of note is that by clicking into the `Point` in the below array ang going to it's `Edit` view, you can quickly edit it's underlying coordinates.

```Smalltalk
{1 . 2. 3. 4. (NeoJSONReader fromString: (ZnClient new get: 'https://httpbin.org/json')). Object new. 2@2}
```

# Caveats

This tool can let you quickly modify the internals of objects (especially when you are modifying non-public slot values) and thus can be great for prototyping, debugging and troubleshooting. The fact that a value can  be 'editable' does not mean that you should change it or that changing it will not have unwanted side-effects, even after undoing. Here be dragons.
