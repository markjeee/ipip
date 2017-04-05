require 'rake/testtask'
require 'minitest'

$: << File.expand_path('../lib', __FILE__)

require 'big_five_results_poster'
require 'big_five_results_text_serializer'

RESULTS_FILE = File.expand_path('../test/test_results.txt', __FILE__)

Rake::TestTask.new do |t|
  t.libs << %w(test lib)
  t.pattern = 'test/**/*_test.rb'
end

task :default => :test

desc 'Perform actual submission of parsed results'
task :go do
  results = File.read(RESULTS_FILE)

  ts = BigFiveResultsTextSerializer.new(results)
  rp = BigFiveResultsPoster.new(ts.hash)

  if rp.post
    puts 'Done POST, recieved response (%s): %s' % [ rp.resp_code, rp.resp_token ]
  else
    puts "Done POST, recieved error (%s):\n%s" % [ rp.resp_code, rp.resp_body ]
  end
end
