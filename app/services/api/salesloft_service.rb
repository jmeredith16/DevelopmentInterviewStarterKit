module API
  class SalesloftService < BaseService
    class SalesloftError < StandardError; end

    def self.people
      protocol = ENV['SALESLOFT_PROTOCOL']
      uri = "#{ENV['SALESLOFT_URI']}/v#{ENV['SALESLOFT_API_VERSION']}"
      headers = { Authorization: "Bearer #{ENV['SALESLOFT_APPLICATION_SECRET']}" }
      parameters = {
        include_paging_counts: true,
        per_page: 100,
      }
      url = "#{uri}/people.json"
      page = 1
      result = nil
      results = []

      while page == 1 || result['metadata']['paging']['total_pages'] >= page
        result = get(protocol, url, parameters.merge(page: page), headers)

        if err = (result['errors'] || result['error'])
          raise SalesloftError, "Error querying Salesloft API: #{err}"
        else
          result['data'].each do |d|
            results << Person.new(d['display_name'], d['email_address'], d['title'])
          end
        end

        page += 1
      end

      results
    end
  end
end
