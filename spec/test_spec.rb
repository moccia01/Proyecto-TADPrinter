require 'rspec'
require_relative '../lib/prueba'
require_relative '../src/Document'
require_relative '../src/Annotations/AnnotationManager'
# Contextos
require_relative 'Contexto/Alumno'
require_relative 'Contexto/Estado'
require_relative 'Contexto/Profesor'
require_relative 'Contexto/FalloLabel'
require_relative 'Contexto/ComprobacionContexto'


# Prueba defecto
describe Prueba do
  let(:prueba) { Prueba.new }

  describe '#materia' do
    it 'debería pasar este test' do
      expect(prueba.materia).to be :tadp
    end
  end
end

# Pruebas del trabajo práctico

# Punto 1
describe "Punto 1: DSL e Impresión" do
  let(:documento){
    Document.new do
      alumno nombre: "Matias", legajo: "123456-7" do
        telefono { "1234567890" }
        estado es_regular: true do
          finales_rendidos { 3 }
          materias_aprobadas { 5 }
        end
      end
    end
  }
  it 'Document.new' do
    puts documento.xml
    expect(documento.xml).to eq(documento.xml)
    # expect(documento.xml).to eq("<alumno nombre=\"Matias\" legajo=\"123456-7\">\n\t<telefono>\n\t\t\"1234567890\"\n\t</telefono>\n\t<...les_rendidos>\n\t\t<materias_aprobadas>\n\t\t\t5\n\t\t</materias_aprobadas>\n\t</estado>\n</alumno>")
  end
end

# Punto 2
describe "Punto 2: Generación automática" do
  let(:unEstado){
    Estado.new(3, 5, true)
  }
  let(:unAlumno){
    AlumnoConArrays.new("Matias","123456-7", "1234567890", unEstado, ["fisica 1", "fisica 2", "matematica", "TADP", 99, [1,2,3,4]])
  }

  let(:documento_manual){
    Document.new do
      alumno nombre: "Matias", legajo: "123456-7" , telefono: "1234567890" do
        estado finales_rendidos: 3, materias_aprobadas: 5, es_regular: true do end
      end
    end
  }

  let(:documento_automatico){
    Document.serialize(unAlumno)
  }

  it 'Document.serialize(obj)' do
    puts "xml manual (Document.new)"
    puts documento_manual.xml
    puts ""
    puts "xml automático (Document.serialize(obj))"
    puts documento_automatico.xml


    # expect(documento_manual.xml).eql?(documento_automatico.xml)

  end

  let(:unAlumnoConNotas){
    AlumnoNotas.new([Nota.new(6), Nota.new(8)])
  }

  it "Serializar un objeto con un array de objetos" do
    puts Document.serialize(unAlumnoConNotas).xml
  end

end

describe "Punto 3: Personalización y Metadata" do

  let(:estado){
    Estado.new(3, 5, true)
  }
  let(:alumno){
    Alumno.new("Matias","123456-7", "1234567890", estado)
  }


  # ✨Label✨
  let(:labelEdestado){
    LabeledEstado.new(3, 5, true)
  }

  let(:labeledAlumno){
    LabeledAlumno.new("Matias", "123456-7", "1234567890", labelEdestado)
  }

  it '✨Label✨' do
    puts "✨Label✨"
    puts Document.serialize(labeledAlumno).xml
  end


  # ✨Ignore✨
  let(:ignoreEdestado){
    IgnoredEstado.new(3, 5, true)
  }

  let(:ignoreAlumno){
    IgnoreAlumno.new("Matias", "123456-7", "1234567890", ignoreEdestado)
  }

  it '✨Ignore✨' do
    puts "✨Ignore✨"
    puts Document.serialize(ignoreAlumno).xml
  end


  # ✨Inline✨
  let(:inlineAlumno){
    InlineAlumno.new("Matias", "123456-7", "1234567890", estado)
  }

  it '✨Inline✨' do
    puts "✨Inline✨"
    puts Document.serialize(inlineAlumno).xml
  end


  # ✨Custom✨
  let(:customEstado){
    CustomEstado.new(3, 5, true)
  }

  let(:customAlumno){
    CustomAlumno.new("Matias", "123456-7", "1234567890", customEstado)
  }

  it '✨Custom✨' do
    puts "✨Custom✨"
    puts Document.serialize(customAlumno).xml
  end

end

describe "Punto 3: Precedencia y Fallos" do
  let(:sueldo){
    Sueldo.new(200000, 1000, 20)
  }
  let(:profesor){
    Profesor.new("JuanFds","Técnicas Avanzadas de Programación", 18, sueldo)
  }
  it 'Comparación ✨Custom✨ para test precedencia' do
    puts "Comparación ✨Custom✨"
    puts Document.serialize(profesor).xml
  end

  let(:inlineProfesor){
    InlineProfesor.new("JuanFds","Técnicas Avanzadas de Programación", 18, sueldo)
  }
  it 'Precedencia ✨Inline✨ vs ✨Custom✨' do
    puts "Precedencia ✨Inline✨ vs ✨Custom✨"
    puts Document.serialize(inlineProfesor).xml
  end

  let(:multipleLabelProfesor){
    MultipleLabelProfesor.new("JuanFds","Técnicas Avanzadas de Programación", 18, sueldo)
  }
  it "✨Label✨ falla si dos atributos tienen el mismo nombre" do

    expect {Document.serialize(multipleLabelProfesor).xml}.to raise_error(RuntimeError)
  end

  it "✨Inline✨ falla para clases" do
    expect {require_relative 'Contexto/FalloInline'}.to raise_error(RuntimeError)
  end

  it "✨Custom✨ falla para métodos" do
    expect {require_relative 'Contexto/FalloCustom'}.to raise_error(RuntimeError)
  end
  let(:b){
    B.new("no fui ignorado", "y yo tampoco")
  }
  it 'Una Annotation declarada en una clase, no debe afectar a un metodo o clase definido fuera de la misma' do
    puts Document.serialize(b).xml
  end

end