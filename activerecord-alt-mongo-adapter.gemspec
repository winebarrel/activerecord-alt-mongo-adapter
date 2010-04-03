Gem::Specification.new do |spec|
  spec.name              = 'activerecord-alt-mongo-adapter'
  spec.version           = '0.1.0'
  spec.summary           = 'activerecord-alt-mongo-adapter is a MongoDB adapter for ActiveRecord.'
  spec.files             = Dir.glob('lib/**/*') + Dir.glob('spec/**/*') + %w(README)
  spec.author            = 'winebarrel'
  spec.email             = 'sgwr_dts@yahoo.co.jp'
  spec.homepage          = 'http://araltmongo.rubyforge.org/'
  spec.has_rdoc          = true
  spec.rdoc_options      << '--title' << 'activerecord-alt-mongo-adapter is a MongoDB adapter for ActiveRecord.'
  spec.extra_rdoc_files  = %w(README)
  spec.rubyforge_project = 'araltmongo'
  spec.add_dependency('activerecord')
end
