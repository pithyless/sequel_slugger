# encoding: UTF-8
#
require 'riot'
require 'sqlite3'
require 'sequel'
require 'sequel_slugger'

# require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
# $LOAD_PATH.unshift(File.dirname(__FILE__))
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# Create model to test on
DB = Sequel.sqlite
DB.create_table :items do
  primary_key :id
  String :name
  String :slug
  String :sluggie
end

class Item < Sequel::Model; end

describe "Slugger" do
  setup do
    Item.plugin :slugger,
                :source => :name,
                :target => :slug
  end

  asserts { Item.plugins.include? Sequel::Plugins::Slugger }
  asserts { Item.respond_to? :find_by_slug }

  asserts("should generate slug during validation") {
    item = Item.new(:name => 'Günther & Friends!')
    item.valid?
    item.slug
  }.equals('gunther-and-friends')
end

# TODO: :source can be Proc

context 'options handling' do
  setup do
    Item.plugin :slugger,
                :source    => :foo,
                :target    => :bar,
                :update    => true
    Item
  end

  asserts { topic.slugger_options[:source] }.equals(:foo)
  asserts { topic.slugger_options[:target] }.equals(:bar)
  asserts { topic.slugger_options[:update] }.equals(true)

  context 'missing source option' do
    setup { class Item < Sequel::Model; end }
    asserts { Item.plugin :slugger
    }.raises(ArgumentError, 'Slugger requires :source column')
  end

  context 'default target option' do
    setup { class Item < Sequel::Model; end; Item }
    asserts { 
      topic.plugin :slugger, :source => :name
      topic.slugger_options[:target]
    }.equals(:slug)
  end

  asserts { Item.slugger_options[:source] = 'xy' 
  }.raises(RuntimeError, "can't modify frozen hash")

end

context 'Sub Classing' do
  setup { Item.plugin :slugger, :source => :foo }
  setup { class SubItem < Item; end; SubItem }

  denies { topic.slugger_options }.nil

  context "changes in sub class" do
    hookup { SubItem.plugin :slugger, :source => :test }
    asserts { SubItem.slugger_options[:source] }.equals(:test)
    asserts { Item.slugger_options[:source] }.equals(:foo)
  end
end

context 'methods' do
  setup { Item.plugin :slugger, :source => :name, :target => :sluggie }
  setup { Item }

  context '#:target= method' do
    asserts {
      item = topic.new(:name => 'Günther & Friends!')
      item.sluggie = item.name
      item.sluggie
    }.equals('gunther-and-friends')
  end

  context '#::find_by_slug class method' do
    setup { Item.create(:name => 'Günther & Friends!') }
    asserts_topic.equals { Item.find_by_slug('gunther-and-friends') }
    asserts { Item.find_by_slug('gunther') }.nil
  end
end

context 'updating slug' do
  setup { Item.plugin :slugger, :source => :name }
  setup { Item.create(:name => 'Günther & Friends!') }

  asserts { topic.slug }.equals('gunther-and-friends')

  # TODO: is this OK?
  context 'is not protected by read-only' do
    hookup { topic.slug = 'foo-bar'; topic.save }
    asserts(:slug).equals('foo-bar')
  end

  context 'but does not update by default' do
    hookup { topic.name = 'Foo Baz'; topic.save }
    asserts(:slug).equals('gunther-and-friends')
  end

  context ':update => true' do
    setup { Item.plugin :slugger, :source => :name, :update => true }
    setup { Item.create(:name => 'Old Slug') }

    hookup { topic.update(:name => 'New Slug') }
    asserts(:slug).equals('new-slug')
  end
end
