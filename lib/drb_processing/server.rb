require 'drb'
require 'drb_processing/method_tee'

module DRbProcessing

class Server < MethodTee
  
  %w{
    clone
    display
    dup
    extend
    freeze
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
    instance_eval
  }.each do |method|
    instance_eval "def #{method}(*args); raise NoMethodError; end"
  end
  
  def initialize(uri = 'druby://0.0.0.0:9000')
    super()
    @uri = uri
  end
  def add_app(app)
    add_method_tee(app)
  end
  def remove_app(app)
    remove_method_tee(app)
  end
  def start
    DRb.start_service(@uri, self)
  end
  def stop
    DRb.stop_service
  end
end

end