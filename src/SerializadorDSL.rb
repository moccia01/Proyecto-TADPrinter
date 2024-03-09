require_relative 'AnexoGeneradorDeStringsXML'


class SerializadorDSL

  def initialize
    @tagRoot = nil
    @tagPila = []
  end


  private def method_missing(name, *args, &bloque)
    # Crear tag principal con label = nombre del metodo
    nuevo_tag = Tag.with_label(name.to_s)

    # Agregar atributos
    atributos = args.first || {}
    atributos.each do |nombre, valor|
      nuevo_tag.with_attribute(nombre, valor)
    end

    # Caso a revisar / refactorizar
    if SerializadorDSL.es_ultimo?(bloque) && bloque
      nuevo_tag.with_child(bloque.call)
    end

    # si es el primero, pasa a ser el root, sino es hijo del root
    if @tagPila.empty?
      @tagRoot = nuevo_tag
    else
      @tagPila.last.with_child(nuevo_tag)
    end

    @tagPila.push(nuevo_tag)
    instance_eval(&bloque) if block_given? #si hay un bloque de codigo, ejecuto otro instance_eval
    @tagPila.pop

  end

  def self.es_ultimo?(bloque)
    begin
      Object.new.instance_exec(&bloque)
    rescue NoMethodError
      false
    else
      true
    end
  end

end