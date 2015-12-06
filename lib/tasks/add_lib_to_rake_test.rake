namespace :test do

  desc "add support for rake test:lib"
  Rake::TestTask.new(:lib => "test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/lib/**/*_test.rb'
    t.verbose = false
  end

end
