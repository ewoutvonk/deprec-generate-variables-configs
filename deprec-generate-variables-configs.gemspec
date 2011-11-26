# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "deprec-generate-variables-configs"
  s.version     = "0.9.9"
  s.authors     = ["Ewout Vonk"]
  s.email       = ["dev@ewout.to"]
  s.homepage    = "https://github.com/ewoutvonk/deprec-generate-variables-configs"
  s.summary     = %q{extension for generating capistrano recipe files with only variables to set for deprec, one for each deprec recipe}
  s.description = %q{extension for generating capistrano recipe files with only variables to set for deprec, one for each deprec recipe}

  s.rubyforge_project = "deprec-generate-variables-configs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "deprec"
  s.add_runtime_dependency "capistrano-variables-namespaces-list"
  s.add_runtime_dependency "capistrano"
end
