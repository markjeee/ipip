require File.expand_path('../test_helper', __FILE__)
require 'minitest/autorun'
require 'webmock/minitest'

require 'big_five_results_poster'
require 'big_five_results_text_serializer'

class ResultsPosterTest < MiniTest::Test
  BFRP = BigFiveResultsPoster
  BFRTS = BigFiveResultsTextSerializer

  def setup
    @res = TestHelper.read_test_results
    @ts = BFRTS.new(@res)
    @rp = BFRP.new(@ts.hash)
  end

  def test_post_body
    pd = @rp.send(:post_body)
    assert_kind_of(String, pd)
    refute_empty(pd)
  end

  def test_post_request
    uri = @rp.send(:post_uri)
    request = @rp.send(:post_request, uri)

    refute_empty(request.body)
    assert_kind_of(Net::HTTP::Post, request)
  end

  def test_post
    test_token = '1234567890'

    stub_request(:post, BFRP::POST_URL).
      to_return(:body => test_token, :status => 201)

    assert(@rp.post)
    assert_equal(@rp.resp_code, '201')
    assert_kind_of(String, @rp.resp_token)
    assert_equal(@rp.resp_token, test_token)
  end

  def test_post_fail
    stub_request(:post, BFRP::POST_URL).
      to_return(:body => 'Something went wrong', :status => 422)

    refute(@rp.post)
    assert_equal(@rp.resp_code, '422')
    assert_nil(@rp.resp_token)
  end
end
