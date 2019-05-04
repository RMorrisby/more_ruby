
class NilClass

    # A simple routing method in case your empty array is actually nil
    # If you're calling empty?, you care if there is data in there, not if the object is actually an array
    # nil is obviously empty, so return true instead of NoMethodError
    def empty?
        true
    end
end