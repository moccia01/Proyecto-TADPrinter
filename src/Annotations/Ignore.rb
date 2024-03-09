

module AnnotationManager
  class Ignore
    include Annotation

    def ignored_tag
      tag  = IgnoredTag.new
      return tag
    end

    class IgnoredTag
      def xml

      end
    end
  end
end