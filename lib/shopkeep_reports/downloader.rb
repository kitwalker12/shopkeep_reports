module ShopkeepReports
  class Downloader
    def initialize
      raise ShopkeepException, "Configuration is invalid" unless Configuration.instance.valid?
    end

    def customer_report
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/customers/create_export'), 'post')
    end

    def sales_report(start_date = nil, end_date = nil)
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/exports/sales/new'), 'get', start_date, end_date)
    end

    def sold_items_report(start_date = nil, end_date = nil)
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/sold_items/new_export'), 'get', start_date, end_date)
    end

    def returns_report(start_date = nil, end_date = nil)
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/returns/new_export'), 'get', start_date, end_date)
    end

    def returned_items_report(start_date = nil, end_date = nil)
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/returned_items/new_export'), 'get', start_date, end_date)
    end

    def download_inventory
      Client.instance.authorize
      Client.instance.download_report_link(configuration.uri('/stock_items_exports/export_bulk_inventory'))
    end

    def download_transactions(args = {})
      start_date = args.fetch(:start_date, Time.now.beginning_of_day)
      end_date = args.fetch(:end_date, Time.now)
      detailed = args.fetch(:detailed, false)
      tenders = args.fetch(:tenders, false)
      link = ""
      if detailed == true
        link = "/exports/items"
      elsif tenders == true
        link = "/exports/tenders"
      end
      Client.instance.authorize
      Client.instance.download_transaction_report_link(configuration.transaction_uri(link), start_date.iso8601, end_date.iso8601)
    end

    def summary_report(type, start_date = nil, end_date = nil)
      start_date = Time.now.beginning_of_day if start_date.nil?
      end_date = Time.now.end_of_day if end_date.nil?

      query = {
        start: start_date.strftime("%Y-%m-%dT%H:%M:%S.%3N"),
        finish: end_date.strftime("%Y-%m-%dT%H:%M:%S.%3N"),
      }

      Client.instance.authorize
      Client.instance.summary_report(configuration.reporting_uri("/#{type}"), query)
    end

    def operation_summary(start_date = nil, end_date = nil)
      summary = summary_report('operation_summary', start_date, end_date)
      mappings = { 'average_items_per_sale' => :to_f }
      # *most* keys should be integers, but not all. O_o
      summary.each do |k, v|
        summary[k] = v.send(mappings[k] || :to_i)
      end
    end

    def operations_by_hour(start_date = nil, end_date = nil)
      summary_report('operations_by_hour', start_date, end_date)
    end

    def tenders_summary(start_date = nil, end_date = nil)
      summary_report('tenders_summary', start_date, end_date)
    end

    def top_selling_items(start_date = nil, end_date = nil)
      summary_report('top_selling_items', start_date, end_date)
    end

    private
    def configuration
      ShopkeepReports.configuration
    end
  end
end
