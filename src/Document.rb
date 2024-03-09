require_relative 'AnexoGeneradorDeStringsXML'
require_relative 'SerializadorDSL'
require_relative 'SerializadorOBJ'


class Document

  def initialize(*args, &bloque)
    serializador = SerializadorDSL.new
    @tagRoot = serializador.instance_exec(*args, &bloque) if bloque
  end

  def self.serialize(obj)
    # tiene que retornar el tag serializando el objeto
    serializador = SerializadorOBJ.new
    serializador.serializar(obj)
  end

  def xml
    @tagRoot.xml
  end
end




