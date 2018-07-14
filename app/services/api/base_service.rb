module API
  class BaseService
    def self.get(protocol, uri, parameters, headers)
      url = build_url(protocol, uri, parameters)

      begin
        response = HTTParty.get(url, headers: headers)
        return JSON.parse(response.body)
      rescue HTTParty::Error => e
        return { error: "Something went wrong in HTTParty" }
      rescue JSON::ParserError => e
        return { error: "Unable to parse the recieved response as JSON" }
      rescue StandardError => e
        return { error: "An unknown error occured" }
      end
    end

    def self.build_url(protocol = "https", uri, parameters)
      "#{protocol}://#{uri}?#{parameters.map { |k, v| "#{k}=#{v}" }.join('&')}"
    end
  end
end
