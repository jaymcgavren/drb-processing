# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "drb-processing/version"

Gem::Specification.new do |s|
  s.name        = "drb-processing"
  s.version     = DrbProcessing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jay McGavren"]
  s.email       = ["jay@mcgavren.com"]
  s.homepage    = "http://github.com/jaymcgavren/drb-processing"
  s.summary     = %q{A server that allows multiple users to view and program a shared Ruby-Processing sketch.}
  s.description = %q{A server that allows multiple users to view and program a shared Ruby-Processing sketch.}

  s.rubyforge_project = "drb-processing"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
