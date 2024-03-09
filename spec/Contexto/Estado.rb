require_relative '../../src/Annotations/AnnotationManager'


class Estado
  attr_reader :finales_rendidos, :materias_aprobadas, :es_regular

  def initialize(finales_rendidos, materias_aprobadas, es_regular)
    @finales_rendidos = finales_rendidos
    @es_regular = es_regular
    @materias_aprobadas = materias_aprobadas
  end
end

✨Label✨("situacion")
class LabeledEstado
  attr_reader :finales_rendidos, :materias_aprobadas, :es_regular

  def initialize(finales_rendidos, materias_aprobadas, es_regular)
    @finales_rendidos = finales_rendidos
    @es_regular = es_regular
    @materias_aprobadas = materias_aprobadas
  end
end


✨Ignore✨
class IgnoredEstado
  attr_reader :finales_rendidos, :materias_aprobadas, :es_regular

  def initialize(finales_rendidos, materias_aprobadas, es_regular)
    @finales_rendidos = finales_rendidos
    @es_regular = es_regular
    @materias_aprobadas = materias_aprobadas
  end
end


✨Custom✨ do |obj|
  estado do
  regular { obj.es_regular }
  pendientes { obj.materias_aprobadas - obj.finales_rendidos }
  end
end


class CustomEstado
  attr_reader :finales_rendidos, :materias_aprobadas, :es_regular

  def initialize(finales_rendidos, materias_aprobadas, es_regular)
    @finales_rendidos = finales_rendidos
    @es_regular = es_regular
    @materias_aprobadas = materias_aprobadas
  end
end