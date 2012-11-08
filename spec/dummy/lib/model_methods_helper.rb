require 'find'
class ModelMethodsHelper

  # finds or makes a model based on the given attributes
  # @param [Constant] model_name The name of the model
  # @param [Hash] attributes The attributes to find the model or add to the new one
  def self.find_or_make_by_attributes(model_name, attributes)
    instances = model_name.where(attributes)
    if instances.empty?
      return model_name.make(attributes)
    else
      return instances.first
    end
  end

  # Uses the descendants_of method to determine the model structure
  # Then tableizes and converts to symbol
  #
  # Load all models must be run for accurate descendants list
  # it is now being called every time this method is called
  # for now it works because this is only called one time when the authorization config is loaded on initialize
  # if this ever changes, this code may need to be update (2-15-2012)
  #
  # @return [Array] Array with file names underscored and pluralized in the format [:users, :case_placements, :roles, :job_locations, ... ]
  def self.get_model_symbol_array
    # Old method:
    # Major redesign of this method that finds namespaced models
    # Finds all files in the given folder, tries to find the ruby files
    # Then processes the names to get the names we need for the code
    #
    # @return [Array] Array with file names underscored and pluralized in the format [:users, :case_placements, :roles, :job_locations, ... ]
    #model_array = []
    #Find.find("#{Rails.root.to_s}/app/models") do |model_path|
    #  if model_path.match(/\.rb$/)
    #    model_path = model_path.gsub("#{Rails.root.to_s}/app/models/", "")
    #    model_path = model_path.gsub("/","_")
    #    model_path = model_path.gsub(/\.rb$/, "")
    #    model_array.push model_path.pluralize.to_sym
    #  end
    #end
    #return model_array

    # new method
    self.load_all_models
    # returns the table name if there is one or tableizes the model name if not
    # our permissions system generally uses table names for model permissions
    return self.descendants_of(ActiveRecord::Base).map{ |m| m.abstract_class ? m.to_s.tableize.to_sym : m.table_name.to_sym }
  end

  # Requires all models so that they are visible in the object space
  # This is only necessary when we are not caching classes
  def self.load_all_models
    if !::Rails.application.config.cache_classes
      Dir[Rails.root.join("app/models/**/*.rb")].each {|f| require f}
    end
  end

  # Return a list of descendants of the given model.
  #
  # If direct is set to true, only return immediate descendants
  # The load_all_models must be called before this is called or the result may not be correct
  #
  # @param [Constant] parent_class The parent class to look for descendants for
  # @param [Boolean] direct Whether to look for all descendants or immediate descendants
  # @return [Array] An array of class constants that satisfy the conditions of the parameters
  def self.descendants_of(parent_class, direct = false)
    classes = []
    ObjectSpace.each_object(::Class).each do |klass|
      if direct
        classes << klass if klass.superclass == parent_class
      else
        classes << klass if klass < parent_class
      end
    end
    return classes
  end

  # Convenience method to return the results of descendants_of with direct set to true 
  #
  # The load_all_models must be called before this is called or the result may not be correct
  #
  # @param [Constant] parent_class The parent class to look for descendants for
  # @return [Array] An array of class constants that satisfy the conditions of the parameters
  def self.direct_descendants_of(parent_class)
    return self.descendants_of(parent_class, true)
  end
end
