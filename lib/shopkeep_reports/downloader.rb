module ShopkeepReports
  class Downloader
    def initialize
      raise ShopkeepException, "Configuration is invalid" unless Configuration.instance.valid?
    end

    def customer_report
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/customers/create_export'), 'post')
    end

    def sales_report
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/exports/sales/new'))
    end

    def sold_items_report
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/sold_items/new_export'))
    end

    def returns_report
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/returns/new_export'))
    end

    def returned_items_report
      Client.instance.authorize
      Client.instance.download_report(configuration.uri('/returned_items/new_export'))
    end

    def download_inventory
      Client.instance.authorize
      Client.instance.download_report_link(configuration.uri('/stock_items_exports/export_bulk_inventory'))
    end

    private
    def configuration
      ShopkeepReports.configuration
    end
  end
end