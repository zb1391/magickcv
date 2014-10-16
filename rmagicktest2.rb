require './magick_cv'
include MagickCv

if ARGV.size == 0
  puts "Usage: ruby #{__FILE__} url_of_image"
  exit
end

cvMat = magickcv_read(ARGV[0])

#smooth image
smoothed = cvMat.smooth(CV_GAUSSIAN,3,21)
kernel = IplConvKernel.new(7,            # width
                                   7,            # height
                                   3,            # x_anchor
                                   3,            # y_anchor
                                   CV_SHAPE_RECT # shape of kernel
                                    )
dilated = cvMat.dilate(kernel,1)
dilated2 = cvMat.dilate(nil,3)
eroded = cvMat.erode

# display_image(cvMat,'mat1')
# display_image(cvMat2,'mat2')