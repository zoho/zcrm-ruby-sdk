# ZCRMSDK

The Ruby library for integrating with the Zoho CRM API.

## Installation

There are a couple of ways of installing ZCRMSDKK:

Install 1:

Start by adding this line to your application's Gemfile:

gem 'ZCRMSDK'

And follow it with executing this command:

\$ bundle

Install 2:

To fully install the CRM API wrapper yourself, just execute this command:

\$ gem install ZCRMSDK

## Documentation

### <a href="https://www.zoho.com/crm/developer/docs/server-side-sdks/ruby.html" rel="nofollow">SDK documentation</a>

### <a href="https://www.zoho.com/crm/developer/docs/api/overview.html" rel="nofollow">API Reference</a>

## Usage

### Refer <a href="https://www.zoho.com/crm/developer/docs/server-side-sdks/ruby.html" rel="nofollow">SDK documentation</a> for Usage

### Overriding HTTP client

In order to add a proxy to the HTTP request we can extend `Net::HTTP` through the `ZCRMSDK::HTTPClient`

```ruby
class ZCRMSDK::HTTPClient < Net::HTTP
  def initialize(host, port)
    if proxy_host.present?
      super(host, port, proxy_host, proxy_port, proxy_username, proxy_password)
    end
  end

  private

  def proxy_host
    ....
  end
end
```
