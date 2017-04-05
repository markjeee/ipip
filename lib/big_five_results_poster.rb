require 'net/http'
require 'uri'
require 'json'

class BigFiveResultsPoster
  POST_URL = 'https://recruitbot.trikeapps.com/api/v1/roles/mid-senior-web-developer/big_five_profile_submissions'

  attr_reader :resp_code
  attr_reader :resp_body
  attr_reader :resp_token

  def initialize(results_h)
    @results_h = results_h

    @resp_code = nil
    @resp_body = nil
    @resp_token = nil
  end

  def post
    http = http_conn(post_uri)
    request = post_request(post_uri)
    resp = http.request(request)

    case resp
    when Net::HTTPCreated
      @resp_code = resp.code
      @resp_token = resp.body.strip

      ok = true
    when Net::HTTPUnprocessableEntity
      @resp_code = resp.code
      @resp_body = resp.body.strip

      ok = false
    else
      raise 'Unhandle HTTP response: %s %s' % [ resp.code, resp.msg ]
    end

    ok
  end

  protected

  def http_conn(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.kind_of?(URI::HTTPS)
    http
  end

  def post_request(uri)
    header = { 'Content-Type': 'text/json' }
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = post_body
    request
  end

  def post_body
    @results_h.to_json
  end

  def post_uri
    if defined?(@uri)
      @uri
    else
      @uri = URI.parse(POST_URL)
    end
  end
end
