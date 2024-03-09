require_relative '../../src/Annotations/AnnotationManager'



class MultipleLabelProfesor
  ✨Label✨("name")
  attr_reader :nombre
  ✨Label✨("signature")
  attr_reader :materia
  ✨Label✨("name")
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