require_relative '../../src/Annotations/AnnotationManager'

class A
  ✨Ignore✨
end

class B
  attr_reader :unAtributo, :otroAtributo

  def initialize(unParametro, otroParametro)
    @unAtributo = unParametro
    @otroAtributo = otroParametro
  end
end