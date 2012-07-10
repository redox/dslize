# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dslize/version"

Gem::Specification.new do |s|
  s.name = "dslize"
  s.version = DSLize::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['redox']
  s.email = ['sylvain.utard@gmail.com']
  s.homepage = "https://github.com/utard/dslize"
  s.summary = %q{DSL made easy}
  s.description = %q{}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.requirements << 'xpain'
end
