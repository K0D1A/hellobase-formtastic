require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'

  files = (arg = ARGV[1]) ?
    (File.directory?(arg) ? "#{arg}/**/*_test.rb" : arg) :
    'test/**/*_test.rb'

  t.test_files = FileList[files]
end

task :default => :test
