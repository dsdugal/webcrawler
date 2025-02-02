# frozen_string_literal: true

require "csv"
require "json"
require "net/http"
require "nokogiri"
require "selenium-webdriver"

module WebCrawler

  # A web crawler that dynamically parses web page content and seamlessly handles resolvable HTTP responses.
  #
  class Crawler

    # @param [String] username - page login name (if applicable)
    # @param [String] password - page login password (if applicable)
    #
    def initialize(username = nil, password = nil)
      @username = username
      @password = password
      @browser = nil
      @wait = nil

      # Delay timings (in seconds).
      @delays = OpenStruct.new({
        page_load: 1,
        request: 2,
        retry: 5,
        timeout: 5
      })

      # Gems used to parse different content types.
      @parsers = OpenStruct.new({
        "csv" => CSV,
        "html" => Nokogiri::HTML,
        "json" => JSON,
        "pdf" => PDF::Reader,
        "xml" => Nokogiri::XML,
        "x-yaml" => YAML,
        "x-yml" => YAML,
        "yaml" => YAML,
        "yml" => YAML
      })
    end

    # Parse and return the contents of a web page.
    #
    # @param [Addressable::URI] url - the url of the target web page
    # @param [TrueClass|FalseClass] auth - authenticate using supplied credentials
    # @param [TrueClass|FalseClass] delay - rate-limit http requests using built-in delays
    # @return [Object]
    #
    def get(url, auth: false, delay: true)
      begin
        response = get_static(url, auth, delay)
      rescue WebCrawler::Error => error
        raise error
      end

      parse(response)
    end

    private

    # Parse the contents of a web page that has static elements.
    #
    # @param [Addressable::URI] url - the url of the target web page
    # @param [TrueClass|FalseClass] auth - authenticate using supplied credentials
    # @param [TrueClass|FalseClass] delay - rate-limit http requests using built-in delays
    # @raise [WebCrawler::CredentialError] if authentication fails (where applicable)
    # @raise [WebCrawler::ConnectionError] if a connection cannot be established with the target
    # @return [Net::HTTPResponse]
    #
    def get_static(url, auth, delay)
      response = http_request(url, auth, @delays.request)

      return response if response.is_a?(Net::HTTPSuccess)

      if response.is_a?(Net::HTTPRedirection)
        # Resend the request to the redirect URL.
        path = Addressable::URI.parse(response.header["location"])
        target = path.relative? ? (url + path.to_s[/\w+[\w[:punct:]]+/i) : path

        http_request(target, auth, @delays.retry)
      elsif response.is_a?(Net::HTTPUnauthorized)
        # Resend the request with credentials.
        http_request(url, true, @delays.retry)
      elsif response.is_a?(Net::HTTPTooManyRequests)
        # Resend the request after waiting the given time.
        http_request(url, auth, response.header["retry-after"].to_i)
      else
        raise WebCrawler::UnresolvableError.new(response.code)
      end
    end

    # Send an HTTP GET request to a specified target URL.
    #
    # @param [Addressable::URI] url - the url of the target web page
    # @param [TrueClass|FalseClass] auth - authenticate using supplied credentials
    # @param [Integer] delay - delay the request by the specified number of seconds
    # @raise [WebCrawler::ConnectionError] if a connection cannot be established with the target
    # @return [Net::HTTPResponse]
    #
    def http_request(url, auth, delay = 0)
      sleep(delay)

      # The `get_response` method expects URI methods to be available to it.
      return Net::HTTP.get_response(URI.parse(url)) unless auth

      raise  WebCrawler::CredentialError.new unless (@username && @password)

      options = {
        use_ssl: url.scheme.match?(/https/),
        verify_mode: OpenSSL::SSL::VERIFY_PEER
      }

      Net::HTTP.start(url.host, url.inferred_port, **options) do |connection|
        request = Net::HTTP::Get.new(url.request_uri)
        request.basic_auth(@username, @password)

        connection.request(request)
      end
    rescue SocketError, SystemCallError => error
      raise WebCrawler::ConnectionError.new
    end

    # Parse the body of an HTTP response using the most appropriate gem for that data type. Plaintext is not parsed.
    #
    # @param [Net::HTTPResponse] response - a web server's response to an HTTP GET request
    # @return [Object]
    #
    def parse(response)
      parser = @parsers.dig(response.content_type.split("/").last)

      return response.body unless parser
      return parser.new(response.body) if parser == PDF::Reader
      return parser.safe_load(response.body) if parser == YAML

      parser.parse(response.body)
    end

  end

end
