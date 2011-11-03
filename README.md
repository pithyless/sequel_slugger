Sequel Slugger
==============

Quick Start
-----------

`gem install sequel_slugger`

Opionions
---------

* Magna Carta: a slug is bound to the same validations as all attributes
* Vox Populi: slugs are for the people

That's why `sequel_slugger` generates slugs `before_validation` and
uses the [`stringex`][1] library to generate readable slugs.

Credits
-------

This gem is heavily inspired by [pk's `sequel_sluggable`][0].
If you don't agree with my choices, you should probably use
that one instead.


[0]: https://github.com/pk/sequel_sluggable/
[1]: https://github.com/rsl/stringex
