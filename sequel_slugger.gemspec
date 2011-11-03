# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sequel_slugger/version"

Gem::Specification.new do |s|
  s.name        = "sequel_slugger"
  s.version     = SequelSlugger::VERSION
  s.authors     = ["Norbert Wojtowicz"]
  s.email       = ["wojtowicz.norbert@gmail.com"]
  s.homepage    = "https://github.com/pithyless/sequel_slugger"
  s.summary     = "Opinionated slug plugin for Sequel"
  s.description = s.summary

  s.rubyforge_project = "sequel_slugger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "riot"
end
