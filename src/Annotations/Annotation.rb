module AnnotationManager
  module Annotation
    # metodos y propiedades comunes a todas las annotations
    attr_reader :metodoAsociado, :claseAsociada
    # cada Annotation tiene una lista de clase con las annotations asociados a metodos o clases por separado
    @@annotations_metodos = []
    @@annotations_clases = []
    def initialize(contexto, *args, &bloque)
      @contexto = contexto
    end

    # se definen metodos para vincular metodos o clases basicos y las annotations pisaran y arrojaran error segun corresponda
    def vincular_metodo(clase, symbol_metodo)
      # Comprobar que la clase donde fue definido el método sea la misma donde se inicio la annotation
      return if clase != @contexto
      # almacena clase y metodo
      @metodoAsociado = symbol_metodo
      @claseAsociada = clase
      @@annotations_metodos << self
    end

    def vincular_clase(clase)
      # Commprobar que el contexto donde se creao la annotation se corresponda con la clase a la que esta siendo asociada
      return unless comprobar_contexto_clase(clase)
      # solo almacena la clase
      @metodoAsociado = nil
      @claseAsociada = clase
      @@annotations_clases << self
    end

    def comprobar_contexto_clase(clase)
      # si es main, se toma es correcto
      contexto_es_main = @contexto.to_s == "main"
      # si se trata de otra clase, dentro de la cual se definio esta clase es correcto
      contexto_es_namespace =clase.to_s.start_with?("#{@contexto.to_s}::")
      return contexto_es_main || contexto_es_namespace
    end

    def self.obtener_annotation_metodo(clase_annotation, clase, symbol_metodo)

      annotation = @@annotations_metodos.find do |annot|
        annot.is_a?(clase_annotation) && annot.claseAsociada == clase && annot.metodoAsociado == symbol_metodo
      end

      annotation
    end

    def self.obtener_annotation_clase(clase_annotation, clase)
      annotation = @@annotations_clases.find do |annot|
        annot.is_a?(clase_annotation) && annot.claseAsociada == clase
      end
      annotation

    end

  end
end