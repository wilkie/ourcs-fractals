require 'bundler'
Bundler.require

require 'RMagick'

m = Fractals::Mandelbrot.new(Complex(-0.1528, 1.0397))
m.max_iterations = 100
m.renderer = Fractals::Renderers::RMagickRenderer
m.width = 150
m.height = 150
m.magnification = 25
m.algorithm = Fractals::Algorithms::NormalizedIterationCount
m.theme = Fractals::Themes::Water

list = Magick::ImageList.new
list.delay = 100
list.iterations = 1

(0...50).each do |i|
  m.magnification += (i ** 2)
  blob = m.to_blob('gif')
  puts "Blobbed"
  list << Magick::Image.from_blob(blob)[0]
  puts "Added"
end

list.write('foo.gif')
