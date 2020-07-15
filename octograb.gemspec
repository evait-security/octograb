require_relative 'lib/octograb/version'

Gem::Specification.new do |spec|
  spec.name                        = 'octograb'
  spec.version                     = Octograb::VERSION
  spec.authors                     = ['evait-security']
  spec.summary                     = 'Match the HTTP responses from an input list and a given path against a specific string.'
  spec.homepage                    = 'https://github.com/evait-security/octograb'
  spec.required_ruby_version       = Gem::Requirement.new('>= 2.3.0')
  spec.metadata['source_code_uri'] = 'https://github.com/evait-security/octograb'
  spec.license                     = 'Apache-2.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  spec.add_runtime_dependency 'ruby-progressbar', '~> 1.10', '>= 1.10.1'
  spec.add_runtime_dependency 'typhoeus', '~> 1.4'
end
