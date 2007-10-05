#
# Robby Russell, PLANET ARGON, LLC. <robby@planetargon.com>
#

module PlanetArgon
  module ActiveDelegate
    # Specify which connection in database.yml that this
    # model is responsible for handling.
    # 
    #  class MasterDatabase < ActiveRecord::Base
    #    handles_connection_for :master_database
    #  end
    #
    def handles_connection_for(database)
      self.abstract_class = true  
      self.send(:establish_connection, database)
    end

    # Specify which methods need to be delegated to a different connection
    #
    #  class Animal < ActiveRecord::Base
    #     delegates_connection_to :master_database, :on => [:create, :save, :destroy]
    #  end
    #
    def delegates_connection_to(*options)
      configuration = {:class_name => :master, :on => [:save]}
      configuration[:class_name] = options[0]
      configuration.update(options.pop) if options.last.is_a?(Hash)    
  
      configuration[:on].each do |method_name|
        define_method method_name do
          # TODO: add some configuration options for the environments to avoid the RAILS_ENV conditional
          ActiveRecord::Base.delegate :connection, :to => configuration[:class_name].to_s.camelize.constantize #if RAILS_ENV=='production'
          super
        end
      end
    end
  end
end