# includes de annotations abajo para poder utilizar el modulo interno Annotation
module AnnotationManager
  @@annotations_pendientes = []


  # Metodos de AnnotationManager:
  def self.es_annotation?(name)
    name.to_s.start_with?("✨") && name.to_s.end_with?("✨")
  end

  def self.obtener_nombre_annotation(name)
    #quitar ✨ y agregar Annotation::
    return "AnnotationManager::#{name.to_s.gsub("✨", "")}"
  end

  def self.crear_annotation(contexto, name, *args, &bloque)
    annotation_class_name = obtener_nombre_annotation(name)

    begin
      annotation = Object.const_get(annotation_class_name).new(contexto, *args, &bloque)
      @@annotations_pendientes << annotation
      return annotation
    rescue NameError
      raise NameError, "No existe la annotation #{name}"
      #si no encuentra ninguna arroja error
    end
  end
  # Las clases de las labels estan en archivos separados aprovechando la capacidad de openclases de ruby

  def self.vincular_annotations_metodo(clase, getter)
    @@annotations_pendientes.each do |annotation|
      annotation.vincular_metodo(clase, getter)
    end
    @@annotations_pendientes = []
  end
  def self.vincular_annotations_metodos_multiples(clase, getters)
    getters.each do |getter|
      clonar_annotations_pendientes.each do |annotation|
        annotation.vincular_metodo(clase, getter.to_sym)
      end
    end
    @@annotations_pendientes = []
  end
  def self.vincular_annotations_clase(clase)
    @@annotations_pendientes.each do |annotation|
      annotation.vincular_clase(clase)
    end
    @@annotations_pendientes = []

  end

  def self.clonar_annotations_pendientes
    return @@annotations_pendientes.map do |annotation|
      annotation.clone
    end
  end
end


class Object
  # Extendemos method missing para capturar annotations
  # HAY QUE EVALUAR SI EXTENDER OTRA CLASE EN LUGAR DE OBJECT
  def method_missing(name, *args, &bloque)
    #si no es annotation (entre chi) sigue el lookup
    super unless AnnotationManager.es_annotation?(name)
    AnnotationManager.crear_annotation(self, name, *args, &bloque)

  #   method missing termina aca, annotation manager
  end


  def self.method_added(getter)
    AnnotationManager.vincular_annotations_metodo(self, getter)
  end

  def self.inherited(clase)
    AnnotationManager.vincular_annotations_clase(clase)
  end
end

class Module

  alias_method :alias_attr_accessor, :attr_accessor
  def attr_accessor(*getter_names)
    getters = getter_names.map do |name|
      name.to_sym
    end
    AnnotationManager.vincular_annotations_metodos_multiples(self, getters)

    alias_attr_accessor(*getter_names)
  end

  alias_method :alias_attr_reader, :attr_reader

  def attr_reader(*getter_names)
    getters = getter_names.map do |name|
      name.to_sym
    end
    AnnotationManager.vincular_annotations_metodos_multiples(self, getters)
    alias_attr_reader(*getter_names)
  end

end
# require de Annotation, con comportamiento compartido básico para todas las annotations
require_relative 'Annotation'#extiende AnnotationManager agregando el modulo Annotation que es incluido por cada annotation

# Requires de cada annotation (si se crea una nueva se agrega aca)
require_relative 'Label'
require_relative 'Ignore'
require_relative 'Inline'
require_relative 'Custom'