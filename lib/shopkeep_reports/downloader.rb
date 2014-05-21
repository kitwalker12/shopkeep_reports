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
      query = {
        start_time: start_date.strftime("%B %d %Y %I:%M %p"),
        end_time: end_date.strftime("%B %d %Y %I:%M %p"),
        detailed: detailed,
        tenders: tenders
      }
      Client.instance.authorize
      Client.instance.download_report_link(configuration.uri("/transactions.csv?#{query.to_query}"))
    end

    private
    def configuration
      ShopkeepReports.configuration
    end
  end
end