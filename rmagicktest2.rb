require './magick_cv'
include MagickCv

if ARGV.size == 0
  puts "Usage: ruby #{__FILE__} url_of_image"
  exit
end

cvMat = mat_from_url(ARGV[0])

display_image(cvMat)