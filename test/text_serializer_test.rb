require File.expand_path('../test_helper', __FILE__)
require 'minitest/autorun'
require 'big_five_results_text_serializer'

class TextSerializerTest < MiniTest::Test
  BFRTS = BigFiveResultsTextSerializer

  def setup
    @res = TestHelper.read_test_results
  end

  def test_results_is_a_hash
    ts = BFRTS.new(@res)
    res_h = ts.hash

    assert_kind_of(Hash, res_h)
  end

  def test_results_has_name_and_email
    ts = BFRTS.new(@res)
    res_h = ts.hash

    assert_includes(res_h, 'NAME')
    assert_includes(res_h, 'EMAIL')
  end

  def test_parsed_five_domains
    ts = BFRTS.new(@res)
    res_h = ts.hash

    assert_equal(res_h.keys.count, 7)

    res_h.each do |k,v|
      case v
      when Hash
        assert(v.has_key?('Overall Score'))
        assert(v.has_key?('Facets'))

        v['Facets'].values.each { |v1| assert_kind_of(Integer, v1) }
      end
    end
  end
end
