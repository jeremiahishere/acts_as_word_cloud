ActsAsWordCloud.configure do |config|
  #the default setting for smallest recursive step for calling wordcloud on models
  config.min_depth = 1

  #methods whose values we'll attempt to get for models that don't include the mixin
  config.no_mixin_fields = [:name, :title, :label]
end
