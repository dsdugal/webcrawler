# frozen_string_literal: true

require_relative "webcrawler/crawler"
require_relative "webcrawler/version"

module WebCrawler

  # A generic class used to differentiate between errors that should and should not be handled within.
  #
  class Error < StandardError; end

  # A specialized class used to account for login errors that occur due to the lack of valid credentials.
  #
  class CredentialError < Error

    def initialize
      super("Login failed; missing valid credentials.")
    end

  end

  # A specialized class used when a connection cannot be established with the target for any reason.
  #
  class ConnectionError < Error

    def initialize
      super("Could not establish a connection with the target.")
    end

  end

  # A specialized class used when status codes are encountered that cannot be resolved.
  #
  class UnresolvableError < Error

    # @param [String] code - HTTP response status code
    #
    def initialize(code)
      super("Server responded with unresolvable status code #{code}.")
    end

  end

end
