require 'drb'

module DRbProcessing

class Client
  
  attr_reader :app
  
  def initialize(app)
    @app = app
  end
  
  def connect(url)
    
    #Start server only if one's not already running.
    begin
      DRb.current_server
    rescue DRb::DRbServerNotFound
      DRb.start_service
    end
    #Ensure DRb doesn't attempt to serialize Processing app.
    @app.extend DRbUndumped unless @app.kind_of? DRbUndumped
    
    undef_insecure_methods(@app)
    @server = DRbObject.new_with_uri(url)
    undef_insecure_methods(@server)
    @server.add_app(@app)
    
  end
  
  def disconnect
    @server.remove_app(@app)
  end
  
  def method_missing(name, *arguments)
    @server.__send__(name, *arguments)
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