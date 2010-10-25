require 'drb-processing/logging'

module DRbProcessing

class MethodTee
  
  class TeeObjectException < Exception
    attr_accessor :results
    def initialize
      @results = {}
    end
  end
  
  include Logging
  
  attr_accessor :halt_on_exception
  attr_accessor :use_first_return_value
  
  def initialize
    @method_tees = []
    self.use_first_return_value = true
  end
  
  def add_method_tee(object)
    log.info "Forwarding method calls to #{object}"
    @method_tees << object
  end
  
  def remove_method_tee(object)
    log.info "No longer sending method calls to #{object}"
    @method_tees.delete(object)
  end
  
  def method_missing(method, *arguments, &block)
    log.debug "#{method}(#{arguments.join(', ')})"
    return_values = []
    results = {}
    exceptions = {}
    @method_tees.each do |object|
      begin
        return_value = object.__send__(method, *arguments, &block)
        return_values << return_value
        results[object] = return_value
      rescue Exception => exception
        exceptions[object] = exception
        if halt_on_exception
          exception = method_tee_exception(results, exceptions)
          log.warn("Got exception:\n#{exception}")
          raise exception
        end
      end
    end
    unless exceptions.empty?
      exception = method_tee_exception(results, exceptions)
      log.warn("Got exception:\n#{exception}")
      raise exception
    end
    use_first_return_value ? return_values.first : return_values
  end
  
  private
  
    def method_tee_exception(results, exceptions)
      parent_exception = TeeObjectException.new
      results.each do |object, result|
        parent_exception.results[object] ||= {}
        parent_exception.results[object][:return_value] = result
      end
      exceptions.each do |object, exception|
        parent_exception.results[object] ||= {}
        parent_exception.results[object][:exception] = exception
      end
      parent_exception
    end
  
end

end