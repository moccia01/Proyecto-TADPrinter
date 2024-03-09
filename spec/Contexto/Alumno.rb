require_relative '../../src/Annotations/AnnotationManager'

class Alumno
  attr_reader :nombre, :legajo, :estado, :telefono, :unaLista
  def initialize(nombre, legajo, telefono, estado)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado
  end
end

✨Label✨("Alumno")
class AlumnoConArrays
  attr_reader :nombre, :legajo, :estado, :telefono, :unaLista
  def initialize(nombre, legajo, telefono, estado, materias)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado

    @unaLista = materias
  end
end

✨Label✨("Estudiante")
class LabeledAlumno
  attr_reader :nombre, :legajo, :estado

  ✨Label✨("Celular")
  def telefono
    @telefono
  end

  ✨Label✨("Situación Académica")
  def estado
    @estado

  end
  def initialize(nombre, legajo, telefono, estado)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado
  end
end

✨Label✨("Alumno")
class IgnoreAlumno
  attr_reader :nombre, :legajo, :estado

  ✨Ignore✨
  def telefono
    @telefono
  end
  def initialize(nombre, legajo, telefono, estado)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado
  end
end

✨Label✨("Alumno")
class InlineAlumno
  ✨Inline✨ {|campo| "||[#{campo}]||" }
  attr_reader :nombre, :legajo

  ✨Ignore✨
  def telefono
    @telefono
  end
  def initialize(nombre, legajo, telefono, estado)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado
  end

  ✨Inline✨ {|estado| estado.es_regular }
  def estado
  @estado
  end
end

✨Label✨("Alumno")
class CustomAlumno
  attr_reader :nombre, :legajo, :estado, :telefono
  def initialize(nombre, legajo, telefono, estado)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado
  end

  ✨Label✨("Situacion")
  def estado
    @estado
  end
end

✨Label✨("Alumno")
class AlumnoNotas
  attr_reader :notas

  def initialize(notas)
    @notas = notas
  end
end


class Nota
  attr_reader :valor

  def initialize(valor)
    @valor = valor
  end
end