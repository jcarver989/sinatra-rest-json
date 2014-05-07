Gem::Specification.new do |s|
  s.name        = 'sinatra-rest-json'
  s.version     = '0.1'

  s.date        = '2014-05-05'
  s.summary     = "Easy rest routes for Sinatra Applciations"
  s.description = ""
  s.authors     = ["Joshua Carver"]
  s.homepage    = 'http://rubygems.org/gems/sinatra-rest-json'
  s.license       = 'MIT'


  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|s|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rake"
end
