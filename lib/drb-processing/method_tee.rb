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
    @method_tees << object
    log.info "Added #{object} - Now forwarding method calls to: #{@method_tees.join(' ')}"
  end
  
  def remove_method_tee(object)
    @method_tees.delete(object)
    log.info "Removed #{object} - Now forwarding method calls to: #{@method_tees.join(' ')}"
  end
  
  def method_missing(method, *arguments, &block)
    return_values = []
    results = {}
    exceptions = {}
    log.debug "Sending #{method}(#{arguments.join(', ')}) to #{@method_tees.join(' ')}"
    @method_tees.each do |object|
      log.debug "#{object}.#{method}(#{arguments.join(', ')})"
      begin
        return_value = object.__send__(method, *arguments, &block)
        return_values << return_value
        results[object] = return_value
      rescue Exception => exception
        exceptions[object] = exception
        if halt_on_exception
          exception = method_tee_exception(results, exceptions)
          log.warn(%Q/Got exception #{exception}: #{exception.message}\n#{exception.results.map{|k, v| "#{k}: #{v}"}.join("\n")}/)
          raise exception
        end
      end
    end
    unless exceptions.empty?
      exception = method_tee_exception(results, exceptions)
      log.warn(%Q/Got exception #{exception}: #{exception.message}\n#{exception.results.map{|k, v| "#{k}: #{v}"}.join("\n")}/)
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