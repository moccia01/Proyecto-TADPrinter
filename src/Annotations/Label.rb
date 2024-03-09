

module AnnotationManager
  class Label
    include Annotation
    def initialize(contexto, *args, &bloque)
      @label = args.first
      super(contexto, *args, &bloque)
    end

    def label
      @label
    end
  end
end