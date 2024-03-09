require_relative 'AnexoGeneradorDeStringsXML'
require_relative 'Annotations/AnnotationManager'
class SerializadorOBJ

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

  def serializar_getter(obj, tag, getter)
    # primero revisamos ✨Ignore✨
    if ignorar_getter?(obj, getter)#EL OTRO ES REDUNDANTE
      # retorna sin hacer nada
      return
    end

    # segundo revisamos ✨Label✨ y obtenemos la etiqueta
    label = obtener_label_getter(obj, getter)

    # segundo no revisar ✨Inline✨ porque no aplica a clases
    bloque_inline = obtener_bloque_inline_getter(obj, getter)
    if bloque_inline
      valor = bloque_inline.call(obj.send(getter))
      agregar_atributo(tag, label, valor)
      return
    end


    # serialización por defecto:
    if tipos_atributos.include?(obj.send(getter).class)
      # si es un tipo primitivo se agrega como atributo
      serializar_atributo(obj, tag, getter, label)
    elsif tipos_array.include?(obj.send(getter).class)
      # si es un array se agrega un hijo(array) con un hijo por elemento
      serializar_array(obj, tag, getter)
    else
      # por descarte, si no es un atributo o array, es un objeto
      serializar_objeto_interno(obj, tag, getter, label)
    end

  end

  def serializar_objeto_interno(obj, tag, getter, label)
    obj_tag = serializar(obj.send(getter))
    # si el label del getter fue modificado por la annotation ✨Label✨ se pisa (asumimos precedencia del label del getter sobre el de la clase)
    obj_tag.with_label(label) if label != label_getter(getter)
    tag.with_child(obj_tag)

  end

  def serializar_atributo(obj, tag, getter, label)
    agregar_atributo(tag, label, obj.send(getter))
    # tag.with_attribute(label, obj.send(getter))
  end

  # serializa un array = agrega tag (al recibido por parametro) con un hijo por elemento
  def serializar_array(obj, tag, array_getter)
    array = obj.send(array_getter)
    array.each do |elemento|
      # tag_elemento = Tag.with_label(label).with_attribute(elemento.class.to_s,elemento)

      tag_elemento = serializar(elemento)


      tag.with_child(tag_elemento)
    end
    tag
  end



  # utilidades de consulta
  def tipos_atributos
    [Float, Integer, String, NilClass, TrueClass, FalseClass]
  end

  def tipos_array
    [Array]
  end

  # obtiene los getters de un obj
  def obtener_getters(obj)
    #listar variables (segun getters)
    variables = obj.instance_variables.map {|elem|
      elem.to_s.slice(1, elem.to_s.length)}

    # en base a los nombres de las variables, obtener sus emtodos (getters)
    getters = obj.public_methods.select do |metodo|
      variables.include?(metodo.to_s)
    end

    # ya no filtra los ignorados porque en la serializacion de cada metodo se evalua el caso ignore
    # getters.select do |unGetter|
    #   !obtener_annotation_getter(AnnotationManager::Ignore, obj.class, unGetter)
    #   end

      # devuelve los getters
    getters
  end

  def obtener_annotation_getter(clase_annotation, clase, getter)
    return AnnotationManager::Annotation.obtener_annotation_metodo(clase_annotation, clase, getter)
  end

  def obtener_annotation_clase(clase_annotation, clase)
    return AnnotationManager::Annotation.obtener_annotation_clase(clase_annotation, clase)
  end

  def obtener_label_object(obj)
    annot_label = obtener_annotation_clase(AnnotationManager::Label, obj.class)

    if annot_label
      return annot_label.label
    else
      return label_obj(obj)
    end
  end

  def label_obj(obj)
    obj.class.to_s
  end

  def obtener_label_getter(obj, getter)
    annot_label = obtener_annotation_getter(AnnotationManager::Label, obj.class, getter)

    if annot_label
      return annot_label.label
    else
      return label_getter(getter)
    end

  end

  def label_getter(getter)
    getter.to_s
  end

  def ignorar_getter?(obj, getter)
    annot_ignore_metodo = obtener_annotation_getter(AnnotationManager::Ignore, obj.class, getter)
    return annot_ignore_metodo || ignorar_clase?(obj.send(getter).class)
  end

  def ignorar_clase?(clase)
    annot_ignore_clase = obtener_annotation_clase(AnnotationManager::Ignore, clase)
    return annot_ignore_clase
  end

  def obtener_bloque_inline_getter(obj, getter)
    bloque = nil
    inline_annot = obtener_annotation_getter(AnnotationManager::Inline, obj.class, getter)
    if inline_annot
      bloque = inline_annot.bloque
    end
    return bloque
  end

  def obtener_bloque_Custom(obj)
    bloque = nil
    custom_annot = obtener_annotation_clase(AnnotationManager::Custom ,obj.class)
    if custom_annot
      bloque = custom_annot.bloque
    end
    return bloque
  end

  def agregar_atributo(tag, label, valor)
    atributos = tag.attributes.keys
    ya_existe_atributo = atributos.include?(label)

    if ya_existe_atributo
      puts "Un XML no puede tener dos atributos con el mismo nombre"
      raise "Un XML no puede tener dos atributos con el mismo nombre"
    else
      tag.with_attribute(label, valor)
      return tag
    end
  end
end