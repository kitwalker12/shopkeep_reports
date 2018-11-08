require 'singleton'
require 'mechanize'
require 'open-uri'

module ShopkeepReports
  class Client
    include Singleton

    @@agent = false
    @@cookie_jar = false
    @@token = false
    @@api_auth_token = false
    @@store = false
    attr_accessor :agent, :cookie_jar, :token

    def self.instance
      @@instance ||= new
    end

    def authorize(params = {})
      return @@agent if @@agent
      @username = configuration.email
      @password = configuration.password
      login
    end

    def download_report(report_link, type = 'get', start_date = nil, end_date = nil)
      new_agent = Mechanize.new
      new_agent.cookie_jar = @@cookie_jar
      case type
      when 'get'
        new_agent.get(report_link)
        if !start_date.blank? and !end_date.blank?
          new_agent.page.forms.first.set_fields({
            'start_date' => start_date.to_s,
            'end_date' => end_date.to_s
          })
        end
        new_agent.page.forms.first.submit
      when 'post'
        new_agent.post(report_link, { 'authenticity_token' => @@token })
      end
      download_link = new_agent.page.link_with(:text => 'Download')
      if download_link.blank?
        file_uri = new_agent.page.forms.first.submit.uri
      else
        file_uri = download_link.uri
      end
      file_name = File.join(configuration.tmp_directory, (file_uri.to_s.split('.csv').first.split('/').last + '.csv'))
      File.open(file_name, "wb") do |file|
        file_uri.open do |uri|
          file.write(uri.read)
        end
      end
      file_name
    rescue Exception => e
      reset
      raise ShopkeepException, "#{e.message}"
    end

    def download_transaction_report_link(report_link, start, finish)
      new_agent = Mechanize.new
      new_agent.cookie_jar = @@cookie_jar
      new_agent.post(report_link, { 'authenticity_token' => @@token, 'start' => start, 'finish' => finish })
      sleep(5)
      export_list = new_agent.get(configuration.uri("/export_center.json"))
      export_json = export_list.body
      export_hash = JSON.parse(export_json)
      report_to_download = export_hash["aaData"].first["url"]
      download = new_agent.get(configuration.uri(report_to_download))
      file_body = download.body
      file_name = File.join(configuration.tmp_directory, download.filename)
      File.open(file_name, "wb") do |file|
        file.write(file_body)
      end
      file_name
    rescue Exception => e
      reset
      raise ShopkeepException, "#{e.message}"
    end

    def download_report_link(report_link)
      new_agent = Mechanize.new
      new_agent.cookie_jar = @@cookie_jar
      download = new_agent.get(report_link)
      file_body = download.body
      file_name = File.join(configuration.tmp_directory, download.filename)
      File.open(file_name, "wb") do |file|
        file.write(file_body)
      end
      file_name
    rescue Exception => e
      reset
      raise ShopkeepException, "#{e.message}"
    end

    def summary_report(report_link, params)
      new_agent = Mechanize.new
      new_agent.cookie_jar = @@cookie_jar
      headers = { 'Authorization' => "Token token=#{@@api_auth_token}", 'X-Shopkeep-Store-Id' => @@store['uuid'], 'X-Shopkeep-Store-Timezone' => @@store['timezone'] }

      JSON.parse(new_agent.get(report_link, params, nil, headers).body)['data']
    end

    private
    def configuration
      ShopkeepReports.configuration
    end

    def login
      agent = Mechanize.new
      agent.get(configuration.uri('/login'))
      form = agent.page.forms.first
      form.login = @username
      form.password = @password
      form.submit
      if match = agent.page.body.match(/var current_store = (\{.+\});$/)
        @@store = JSON.parse(match[1])
      end
      @@cookie_jar = agent.cookie_jar
      @@token = agent.page.at('meta[@name="csrf-token"]')['content']
      @@api_auth_token = agent.page.at('meta[@name="auth-token"]')['content']
      @@agent = agent
    end

    def reset
      @@agent = false
    end
  end
end
