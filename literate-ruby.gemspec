Gem::Specification.new do |s|
  s.name = 'LiterateRuby'
  s.summary = 'A gem to write, so-called, literate ruby.'
  s.description = <<EOF
This gem is hightly inspired by literate haskell. It currently will support
"bird style" which is described in full <a href="https://wiki.haskell.org/Literate_programming#Bird_Style">here</a>
Note: The <pre>lruby -e</pre> feature does not yet work.
EOF
  s.version = '0.2.1'
  s.author = 'Eli Sadoff'
  s.email = 'snood1205@gmail.com'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9.3'
  s.date = '2017-01-11'
  s.executable = 'lruby'
  s.files = %w(Rakefile lib/literate-ruby.rb bin/lruby)
  s.files.concat Dir['lib/literate-ruby/*rb']
  s.files.concat Dir['**/*.rdoc']
  s.test_files = Dir['test/test_*.rb']
  s.homepage = 'https://github.com/snood1205/literate-ruby'
  s.require_paths = %w(lib)
  s.has_rdoc = true
  s.extra_rdoc_files = 'README.md'
  s.rdoc_options << '-t' << 'literate-ruby RDocs' << '-m' << 'README.md'
end
