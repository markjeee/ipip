class BigFiveResultsTextSerializer
  NAME = 'Mark John Buenconsejo'
  EMAIL = 'hi@markjeee.com'

  def initialize(text_results)
    @text_results = text_results
  end

  def hash
    { 'NAME' => NAME,
      'EMAIL' => EMAIL }.merge(parse_text_results)
  end

  protected

  def parse_text_results
    res_h = { }

    domain = nil
    @text_results.scan(/^(\.+)?([^\n\.]+)\.([\.\s]+)?(\d+)$/) do |m|
      if m[0].nil?
        domain = m[1]
        res_h[domain] = { 'Overall Score' => m[3].to_i, 'Facets' => { } }
      else
        unless domain.nil?
          res_h[domain]['Facets'][m[1]] = m[3].to_i
        end
      end
    end

    res_h
  end
end
