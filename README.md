# Vodeclic::AppLogging

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/vodeclic/logger`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vodeclic-logger'
```



And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vodeclic-logger

## Usage
###### Rails
 To enable the vodeclic logger in your rails app, add this to you environement file (staging/production) : 
 
  ```ruby
    Vodeclic::AppLogging.config do|custom_logger|                                                                            
      custom_logger.enabled = true 
    end 
  ```
  
###### Grape : 

To use the vodeclic gem with Grape mount in a Rails app, add this to your app : 
```ruby
class ApiInstrumenter < Grape::Middleware::Base                                                                                                                              
  def initialize(app)                                                                                                                                                        
    @app = app                                                                                                                                                               
  end                                                                                                                                                                        
                                                                                                                                                                             
  def call(env)                                                                                                                                                              
    payload = {                             
      remote_addr:    env['REMOTE_ADDR'],                                                                                    
      request_method: env['REQUEST_METHOD'],    
      request_path:   env['PATH_INFO'],                                                                                     
      request_query:  env['QUERY_STRING'],                                
    }                                                                                                                                                                 
    ActiveSupport::Notifications.instrument "request.api", payload do                                                                                                        
      @app.call(env).tap do |(status, headers, response)|                                                                    
        payload[:params] = env["api.endpoint"].params.to_hash                                                                
        payload[:params].delete("route_info")          
        payload[:params].delete("format")               
        payload[:response_status] = status                                                                                
        payload[:headers_size] = headers.sum {|_, v| v.to_s.bytesize }
        payload[:body_size]    = headers['Content-Length']                                                                  
      end                                        
    end                                      
  end                                         
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vodeclic-logger.

# vodeclic_logger
