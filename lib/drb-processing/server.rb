require 'drb/drbfire'
require 'drb-processing/method_tee'
require 'drb-processing/logging'

module DRbProcessing

class Server < MethodTee
  
  include Logging
  
  %w{
    clone
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
    class_eval
  }.each do |method|
    class_eval "def #{method}(*args); puts('insecure method: #{method}'); end"
  end
  
  def initialize(address = '0.0.0.0', port = 9000)
    super()
    @address = address
    @port = port
  end
  def add_app(app)
    add_method_tee(app)
  end
  def remove_app(app)
    remove_method_tee(app)
  end
  def start
    uri = "drbfire://#{@address}:#{@port}"
    log.info "Starting service at #{uri}"
    DRb.start_service(uri, self, DRbFire::ROLE => DRbFire::SERVER)
  end
  def stop
    log.info "Stopping service"
    DRb.stop_service
  end
end

end