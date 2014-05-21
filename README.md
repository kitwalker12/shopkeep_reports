# ShopkeepReports

Gem for downloading shopkeep reports via mechanize

## Installation

Add this line to your application's Gemfile:

    gem 'shopkeep_reports'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shopkeep_reports

## Usage

### Initialize with ENV variables set

```ruby
# config/initializers/shopekeep.rb
# ENV['SHOPKEEP_EMAIL'] & ENV['SHOPKEEP_PASSWORD'] & ENV['SHOPKEEP_ACCOUNT'] should be set
ShopkeepReports.configure do |c|
  c.tmp_directory = Rails.root
end
```

else

```ruby
ShopkeepReports.configure do |c|
  c.email = 'me@example.com'
  c.password = 'my_password'
  c.account = 'awesomecompany'
  c.tmp_directory = Rails.root
end
```

### Use

Provided functions return a file name stored in your root/tmp directory

```ruby
d = ShopkeepReports::Downloader.new
d.customer_report

d.sales_report(Time.now - 1.month, Time.now)
# OR
d.sales_report

# Similarly start and end date optional parameters for:
d.sold_items_report
d.returns_report
d.returned_items_report

d.download_inventory
d.download_transactions(start_date: Time.now - 1.week, end_date: Time.now, detailed: true, tenders: false)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/shopkeep_reports/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
