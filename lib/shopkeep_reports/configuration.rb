require 'singleton'

module ShopkeepReports
  class Configuration
    include Singleton

    attr_accessor :email, :password, :account, :tmp_directory

    def self.instance
      @@instance ||= new
    end

    def init(args = {})
      @email = default_email
      @password = default_password
      @account = default_account
      @tmp_directory = "/tmp"
      args.each_pair do |option, value|
        self.send("#{option}=", value)
      end
    end

    def valid?
      result = true
      [:email, :password, :account, :tmp_directory].each do |value|
        result = false if self.send(value).blank?
      end
      result
    end

    def uri(path)
      "https://" + @account + ".shopkeepapp.com" + path
    end

    private
    def default_email
      ENV['SHOPKEEP_EMAIL']
    end

    def default_password
      ENV['SHOPKEEP_PASSWORD']
    end

    def default_account
      ENV['SHOPKEEP_ACCOUNT']
    end
  end
end