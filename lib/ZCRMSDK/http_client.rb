require 'net/http'

module ZCRMSDK
  class HTTPClient
    def self.new(*args)
      Net::HTTP.new(*args)
    end
  end
end