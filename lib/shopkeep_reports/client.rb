require 'singleton'
require 'mechanize'
require 'open-uri'

module ShopkeepReports
  class Client
    include Singleton

    @@agent = false
    @@cookie_jar = false
    @@token = false
    attr_accessor :agent, :cookie_jar, :token

    def self.instance
      @@instance ||= new
    end

    private
    def configuration
      BrightpearlApi.configuration
    end
  end
end
