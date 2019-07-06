Gem::Specification.new {|s|
  s.name        = 'voting_systems'
  s.version     = '1.0.0'
  s.date        = '2019-07-03'
  s.summary     = 'Implementations of various voting systems.'
  s.author      = 'Tim Smith'
  s.homepage    = 'https://github.com/smithtim/voting_systems'
  s.license     = 'AGPL-3.0'

  s.files = Dir['lib/**/*.rb']

  s.add_runtime_dependency 'rgl'
}