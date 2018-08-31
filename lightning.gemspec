Gem::Specification.new do |s|
  s.name        = 'lightning_rb'
  s.version     = '0.0.1'
  s.date        = '2018-11-11'
  s.summary     = "Lightning Network"
  s.description = "Connect to the Lightning Network with Ruby. "
  s.authors     = ["Ivan Acosta-Rubio"]
  s.email       = 'ivan@softwarecriollo.com'
  s.files       = Dir['./lib/']
  s.homepage    =
    'http://rubygems.org/gems/lightning'
  s.license       = 'MIT'
  s.add_dependency("grpc", "1.12.0")
  s.add_dependency("grpc-tools", "1.12.0")
end
