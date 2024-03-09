require_relative '../../src/Annotations/AnnotationManager'

class Profesor
  attr_reader :nombre, :materia
  ✨Ignore✨
  attr_reader :horas_semanales

  def initialize(nombre, materia, horas_semanales, sueldo)
    @nombre = nombre
    @materia = materia
    @horas_semanales = horas_semanales
    @sueldo = sueldo
  end

  def sueldo
    @sueldo
  end

end

✨Label✨("Profesor")
class InlineProfesor
  attr_reader :nombre
  ✨Inline✨ { |materia| "TADP"}
  attr_reader :materia
  ✨Ignore✨
  attr_reader :horas_semanales

  def initialize(nombre, materia, horas_semanales, sueldo)
    @nombre = nombre
    @materia = materia
    @horas_semanales = horas_semanales
    @sueldo = sueldo
  end

  ✨Inline✨ {|sueldo| "$#{sueldo.pagar} + Bono por ✨Inline✨ $1000000 => Total = $#{sueldo.pagar + 1000000}" }
  def sueldo
    @sueldo
  end
end

✨Custom✨ do |sueldo| sueldo do
  pagar { "$0 por entrar por ✨Custom✨" } end
end
class Sueldo
  attr_accessor :monto_base, :monto_hora_extra, :horas_extra

  def initialize(monto_base, monto_hora_extra, horas_extra)
    @monto_base = monto_base
    @monto_hora_extra = monto_hora_extra
    @horas_extra = horas_extra

  end

  def pagar
    @monto_base + @monto_hora_extra * @horas_extra
  end

end