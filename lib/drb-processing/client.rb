require 'drb/drbfire'
require 'drb-processing/logging'

module DRbProcessing

class Client
  
  include Logging
  
  attr_reader :app
  
  def initialize(app)
    @app = app
  end
  
  def connect(address, port)
    
    url = "drbfire://#{address}:#{port}"
    
    #Start server only if one's not already running.
    begin
      log.debug "DRb.current_server: "
      log.debug DRb.current_server.to_s
    rescue DRb::DRbServerNotFound => exception
      log.debug %Q/No current server: #{exception.message}\n#{exception.backtrace.join("\n")}/
      DRb.start_service(url, nil, DRbFire::ROLE => DRbFire::CLIENT)
    end
    #Ensure DRb doesn't attempt to serialize Processing app.
    @app.extend DRbUndumped unless @app.kind_of? DRbUndumped
    
    undef_insecure_methods(@app)
    unless @server
      log.info "Connecting to #{url}"
      @server = DRbObject.new_with_uri(url)
      log.info "Connected to #{@server}"
    end
    undef_insecure_methods(@server)
    log.info "Subscribing #{@app} to method calls"
    @server.add_app(@app)
    log.info "Subscribed #{@app} successfully"
    
  end
  
  def disconnect
    @server.remove_app(@app)
  end
  
  def method_missing(name, *arguments)
    log.debug "#{name}(#{arguments.join(', ')})"
    result = @server.__send__(name, *arguments)
    log.debug "result: #{result}"
    result
  end
  
  private
  
    def undef_insecure_methods(object)
      class << object
        %w{
          clone
          define_singleton_method
          display
          dup
          extend
          freeze
          instance_eval
          instance_exec
          instance_variable_defined?
          instance_variable_get
          instance_variable_set
          instance_variables
          public_send
          remove_instance_variable
          send
          tap
          library_loaded?
          load_java_library
          load_libraries
          load_library
          load_ruby_library
        }.each do |method|
          if method_defined?(method.to_sym)
            undef_method(method.to_sym)
          end
        end
      end
    end
  
end

end