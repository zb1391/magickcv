
require './magick_cv'
include MagickCv

describe "Opening an Image from a URL" do

  it "should return a CvMat Object with proper dimensions" do
    cvMat = magickcv_read('http://www.downtownsports.org/assets/court1-2385161e2e1066fcb871ef06b9408905.jpg')
    expect(cvMat.class).to eq(CvMat)
    expect(cvMat.rows).to eq(375)
    expect(cvMat.columns).to eq(500)
  end
end

describe "Simple Image Processing" do
  let!(:cvMat) {magickcv_read('http://www.downtownsports.org/assets/court1-2385161e2e1066fcb871ef06b9408905.jpg')}
  let!(:kernel) {IplConvKernel.new(7,            # width
                                   7,            # height
                                   3,            # x_anchor
                                   3,            # y_anchor
                                   CV_SHAPE_RECT # shape of kernel
                                    )}           # an array to define the shape within the 
                                                 # 7x7 rectangle we created (optional param)
        
  it "should smooth an image" do
    # openCV has a cvSmooth() method to smooth an image
    # seems like only CV_GAUSSIAN and CV_SMOOTH work properly
    # but i figured out how to read the github page at least
    cvMat.smooth(CV_MEDIAN,5)
  end

  describe "dilating" do
    # Dilation - iterate over each pixel taking in a surrounding kernel
    # replace current (anchor) pixel with kernel's maximum value
    # makes everything brighter
    it 'should use the default kernel when none is passed' do
      cvMat.dilate  #default kernel is 3x3 center anchored
      cvMat.dilate! #bang applies operation directly to cvMat
    end

    it 'should use a custom kernel when one is passed' do
      cvMat.dilate(kernel, # supply a kernel
                   2)      # apply the dilation twice    
      
      cvMat.dilate!(kernel,2)

      # give nil to keep default 3x3 kernel
      cvMat.dilate(nil,2)                          
    end
  end

  describe "eroding" do
    # Erosion - iterate over each pixel taking in a surrounding kernel
    # replace current (anchor) pixel with kernel's min value
    # makes everything darker
    it 'should use the default kernel when none is passed 'do
      cvMat.erode  #default kernel is 3x3 center anchored
      cvMat.erode! #bang applies operation directly to cvMat
    end

    it 'should use a cusomt kernel when one is passed' do
      cvMat.erode(kernel, # supply a kernel
                   2)      # apply the dilation twice    
      
      cvMat.erode!(kernel,2)

      # give nil to keep default 3x3 kernel
      cvMat.erode(nil,2)   
    end
  end
end