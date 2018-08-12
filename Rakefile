# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i[spec rubocop]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'test/'
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end
