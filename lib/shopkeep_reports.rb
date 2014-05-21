require "active_support/all"
require "shopkeep_reports/version"
require "shopkeep_reports/configuration"
require "shopkeep_reports/client"
require "shopkeep_reports/downloader"

module ShopkeepReports
  class << self
    attr_accessor :configuration
  end

  class ShopkeepException < StandardError; end

  def self.configure
    Configuration.instance.init
    self.configuration ||= Configuration.instance
    yield(configuration)
  end
end
