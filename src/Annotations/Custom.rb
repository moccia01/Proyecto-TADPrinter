

module AnnotationManager
  class Custom
    include Annotation
    def initialize(contexto, *args, &bloque)
      raise "La annotation ✨Custom✨ no recibio ningun bloque" unless bloque
      @bloque = bloque
      super(contexto, *args, &bloque)
    end

    def bloque
      @bloque
    end

    def vincular_metodo(clase, symbol_metodo)
      puts "La annotation ✨Custom✨ no puede aplicarse a metodos"
      raise "La annotation ✨Custom✨ no puede aplicarse a metodos"
    end
  end
end

#                   -------------------------------------------------------------------------------------
module AnnotationManager
  class Extra
    include Annotation
    def initialize(contexto, *args, &bloque)
      raise "La annotation ✨Extra✨ no recibio ningun bloque" unless bloque
      @label = args.first
      @bloque = bloque
      super(contexto, *args, &bloque)
    end

    def label
      @label
    end
    def bloque
      @bloque
    end

    def vincular_metodo(clase, symbol_metodo)
      raise "La annotation ✨Extra✨ no puede aplicarse a metodos"
    end
  end
end

#                   -------------------------------------------------------------------------------------
# En AnnotationManager.rb

require_relative 'Extra'


#                   -------------------------------------------------------------------------------------
# En SerializadorOBJ.rb
def serializar(obj)
  # primero revisar ✨Ignore✨ y retornar tag con xml = ""
  annot_ignore = ignorar_clase?(obj.class)
  if annot_ignore
    nuevo_tag = annot_ignore.ignored_tag
    # retornamos este tag que entiende :xml y produce un string vacio como indica el enunciado
    return nuevo_tag
  end

  # segundo revisar ✨Label✨ y obtener la etiqueta
  label = obtener_label_object(obj)

  # tercer no revisar ✨Inline✨ porque no aplica a clases (se evalua en serialziar_metodo)

  # cuarto revisar ✨Custom✨ y serializar
  bloque_custom = obtener_bloque_Custom(obj)
  if bloque_custom
    serializador = SerializadorDSL.new
    custom_tag = serializador.instance_exec(obj, &bloque_custom)
    custom_tag.with_label(label)
    return custom_tag
  end

  # quinto revisar ✨Extra✨ y serializar
  bloque_extra = obtener_bloque_extra(obj)
  if bloque_extra
    nuevo_tag = Tag.with_label(obj.to_s)        # Ya que mi label es el del primer parametro, no quiero que reemplace el nombre de mi clase

    valor_extra = obj.instance_eval(&bloque_extra)

    agregar_atributo(nuevo_tag, label, valor_extra)     # El label que está acá me sirve ya que entra en el else de obtener_label_object(obj)
    return nuevo_tag                                    # y retorna el label_obj(obj), método creado por nosotros
  end

  #Serialización de tipos "primitivos":
  if tipos_atributos.include?(obj.class)
    return Tag.with_label(label).with_child(obj)
  end

  # serialización por defecto:
  # poner nombre al nuevo tag
  nuevo_tag = Tag.with_label(label)
  # obtener getters
  getters = obtener_getters(obj)
  # serializar getters
  getters.each do |getter|
    serializar_getter(obj, nuevo_tag, getter)
  end
  # se retorna el tag fabricado
  nuevo_tag
end

def obtener_bloque_extra(obj)
  bloque = nil
  extra_annot = obtener_annotation_clase(AnnotationManager::Extra ,obj.class)

  if extra_annot
    bloque = extra_annot.bloque
  end
  bloque
end