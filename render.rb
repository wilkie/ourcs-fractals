require 'bundler'
Bundler.require

require 'RMagick'

def render(server)
  m = Fractals::Mandelbrot.new(Complex(-0.1528, 1.0397))
  m.max_iterations = 100
  m.renderer = Fractals::Renderers::RMagickRenderer
  m.width = 150
  m.height = 150
  m.magnification = 25
  m.algorithm = Fractals::Algorithms::NormalizedIterationCount
  m.theme = Fractals::Themes::Water

  n = 0

  (0...50).each do |i|
    m.magnification += (i ** 2)
    blob = m.to_blob('gif')
    puts "Blobbed"
    Magick::Image.from_blob(blob)[0].write("public/frame_#{n}.gif")
    n += 1
  end
end

  render 0
