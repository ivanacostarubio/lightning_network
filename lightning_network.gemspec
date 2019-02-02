Gem::Specification.new do |s|
  s.name        = 'lightning_network'
  s.version     = '0.0.2'
  s.date        = '2019-02-01'
  s.summary     = "Lightning Network"
  s.description = "Connect to the Lightning Network with Ruby. "
  s.authors     = ["Ivan Acosta-Rubio"]
  s.email       = '12wordscapital@protonmail.com'
  s.files       = Dir['./lib/*']
  s.homepage    =
    'https://github.com/ivanacostarubio/lightning_network'
  s.license       = 'MIT'
  s.add_dependency("grpc", "1.12.0")
  s.add_dependency("grpc-tools", "1.12.0")
end
