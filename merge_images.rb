require './magick_cv'
include MagickCv

# The goal of this program is to concatenate N Many instances
# of an image resized to 20x20 into one larger file
if ARGV.size != 2   
  puts "Usage: ruby #{__FILE__} url_of_image count"
  exit
end

cvMat = magickcv_read(ARGV[0])
#cvMat = magickcv_read('http://www.downtownsports.org/assets/court1-2385161e2e1066fcb871ef06b9408905.jpg')
count = ARGV[1].to_i


new_dimensions = CvSize.new(20,20)
smaller = cvMat.resize(new_dimensions)

num_rows = count > 50 ? count/50 :  1
num_cols = count > 50 ? 50 : count % 50
concatenated = IplImage.new(20*num_cols, 20*num_rows, cvMat.depth)

cur_row = 0
count.times do |i|
  if (i)%50 == 0 && i != 0
    cur_row = cur_row+1
  end
  cur_col = i%50
  rect = CvRect.new(cur_col*20,cur_row*20,20,20)
  concatenated.set_roi(rect)
  smaller.copy(concatenated)
end


concatenated.reset_roi

display_image(cvMat,'big')
display_image(concatenated,'mat2')
