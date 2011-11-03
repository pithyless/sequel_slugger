Sequel Slugger
==============

A slugger plugin for the people.


Opionions
---------

* Magna Carta: A slug is bound to the same validations as all attributes.
* Vox Populi: Slugs should be pleasant to read.
* Abundans cautela non nocet: Say no to `find_by_pk_or_slug`.

That's why `sequel_slugger` generates slugs `before_validation` and
uses the [`stringex`][1] library to generate readable slugs.

Quick Start
-----------

Add to Gemfile:

    gem 'sequel_slugger'

Migrate your database:
    
    def up
      alter_table :items do
        add_column :title, :string
        add_column :slug,  :string
      end
    end

Update your Sequel model:

    class Item < Sequel::Model
      plugin :slugger, :source => :title,  # required
                       :target => :slug,
                       :update => false
    end


Credits
-------

This gem is heavily inspired by [pk's `sequel_sluggable`][0]. If you don't 
agree with my choices, you should probably use that one instead.

Kudos also to [rsl's `stringex`][1] gem that makes all this possible.


[0]: https://github.com/pk/sequel_sluggable/
[1]: https://github.com/rsl/stringex
