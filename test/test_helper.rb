module TestHelper
  def self.read_test_results
    File.read(test_results_path)
  end

  def self.test_results_path
    File.expand_path('../test_results.txt', __FILE__)
  end
end
