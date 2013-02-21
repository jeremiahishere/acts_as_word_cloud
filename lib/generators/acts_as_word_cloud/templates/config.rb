ActsAsWordCloud.configure do |config|
  # The default recursion depth when looking at data in associations.
  # A min_depth of 1 will look at all fields on the current model and the name of each association.
  # A min_depth of 2 will look at all fields on the current model, all fields on the associations, and all names of the association's associations
  # config.default_search_depth = 1

  # This option is useful when associations do not use the acts_as_word_cloud mixin.
  # When word_cloud is called, the system tries to guess a reasonable name for the associated models.
  # It calls the methods in order meaning it will look for name first.
  # Make sure that the final method in this list is on every model
  # config.default_object_names = [:name, :title, :label, :to_s]

  # A list of models that should never be included on the word cloud
  # Examples include user models, auditing or versioning models, and logging models.
  #
  # Each of the contants in this list will be added to the word cloud attribute, excluded_models.
  # This will happen even when the attribute is included in the mixin call.
  # config.permanently_excluded_models = []
end
