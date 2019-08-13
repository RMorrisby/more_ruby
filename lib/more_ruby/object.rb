require_relative 'super_proxy.rb'

class Object

    private  

    # Method allowing syntax akin to 'super.<parent class method>'
    # Usage : sup.<parent class method>
    def sup  
      SuperProxy.new(self)  
    end
  
  end