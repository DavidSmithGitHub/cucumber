Given /^I am in (.*)$/ do |example_dir_relative_path|
  @dir = examples_dir(example_dir_relative_path)
end

When /^I run cucumber (.*)$/ do |cmd|
  @dir ||= self_test_dir
  Dir.chdir(@dir) do
    @full_cmd = "#{Cucumber::RUBY_BINARY} #{Cucumber::BINARY} --no-color #{cmd}"
    @out = `#{@full_cmd}`
    @status = $?.exitstatus
  end
end

Then /^it should (fail|pass) with$/ do |success, output|
  @out.should == output
  if success == 'fail'
    @status.should_not == 0
  else
    @status.should == 0
  end
end

Then /^the output should contain$/ do |text|
  @out.should include(text)
end

Then /^"(.*)" should contain$/ do |file, text|
  IO.read(file).should == text
end

Then /^"(.*)" should match$/ do |file, text|
  IO.read(file).should =~ Regexp.new(text)
end
