require 'active_delegate'

class ActiveRecord::Base
  class << self # Class methods
    include PlanetArgon::ActiveDelegate
  end  
end