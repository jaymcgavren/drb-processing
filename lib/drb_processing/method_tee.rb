class MethodTee
  
  class TeeObjectException < Exception
    attr_accessor :results
    def initialize
      @results = {}
    end
  end
  
  attr_accessor :halt_on_exception
  
  def initialize
    @method_tees = []
  end
  
  def add_method_tee(object)
    @method_tees << object
  end
  
  def method_missing(method, *arguments)
    # return_values = @method_tees.map{|object| object.__send__(method, *arguments)}
    return_values = []
    results = {}
    exceptions = {}
    @method_tees.each do |object|
      begin
        return_value = object.__send__(method, *arguments)
        return_values << return_value
        results[object] = return_value
      rescue Exception => exception
        exceptions[object] = exception
        raise method_tee_exception(results, exceptions) if halt_on_exception
      end
    end
    unless exceptions.empty?
      raise method_tee_exception(results, exceptions)
    end
    return_values
  end
  
  private
  
    def method_tee_exception(results, exceptions)
      parent_exception = TeeObjectException.new
      results.each do |object, result|
        parent_exception.results[object] ||= {}
        parent_exception.results[object][:result] = result
      end
      exceptions.each do |object, exception|
        parent_exception.results[object] ||= {}
        parent_exception.results[object][:exception] = exception
      end
      parent_exception
    end
  
end