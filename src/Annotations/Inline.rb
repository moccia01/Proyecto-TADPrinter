

module AnnotationManager
  class Inline
    include Annotation
    def initialize(contexto, *args, &bloque)
      raise "La annotation ✨Inline✨ no recibio ningun bloque" unless bloque
      @bloque = bloque
      super(contexto, *args, &bloque)
    end

    def bloque
      @bloque
    end

    def vincular_clase(clase)
      puts "La annotation ✨Inline✨ no puede aplicarse a clases #{clase}"
      raise "La annotation ✨Inline✨ no puede aplicarse a clases #{clase}"
    end
  end
end