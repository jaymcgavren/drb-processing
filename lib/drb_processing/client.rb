require 'drb'

module DRbProcessing

class Client
  
  attr_reader :app
  
  def initialize(app)
    @app = app
    @app.extend DRbUndumped
  end
  
  def connect(url)
    DRb.start_service
    @server = DRbObject.new(nil, url)
    @server.add_app(@app)
  end
  
  def disconnect
    @server.remove_app(@app)
    DRb.stop_service
  end
  
  def method_missing(name, *arguments)
    @server.__send__(name, *arguments)
  end
  
end

end