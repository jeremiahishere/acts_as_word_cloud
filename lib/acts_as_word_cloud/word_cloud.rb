module ActsAsWordCloud
  module WordCloud
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # this is a sample mixin name only
      def acts_as_word_cloud(args)
        # do things
        include ActsAsWordCloud::WordCloud::InstanceMethods
      end
    end

    module InstanceMethods
    end
  end
end
