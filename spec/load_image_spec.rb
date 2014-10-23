
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

  describe "morphology" do
    # Use the cvMorphology method to open/close an image
    # Opening is often used in binary images
    it "should perform an open" do
      dest = cvMat.morphology(CV_MOP_OPEN)
    end
    it "should perform open with more specific arguments" do
      dest = cvMat.morphology(CV_MOP_OPEN,
                              kernel,      # specify a kernel (use nil for default)
                              1)           # number of times to perform operation
                                           # number = 2: dilate-dilate-erode-erode
    end

    # It is the processing of dilating and then eroding
    # Closing is used to remove noise (eroding and then dilating)
    it "should perform a close" do
      dest = cvMat.morphology(CV_MOP_CLOSE)
    end

    it "should perform close with more specific arguments" do
      dest = cvMat.morphology(CV_MOP_CLOSE,
                              kernel,       # specify a kernel (use nil for default)
                              1)            # number of times to perform operation
                                            # number = 2: erode-erode-dilate-dilate
    end 

    # gradient(src) = dilate(src)-erode(src)
    # on boolean images it isoltes the perimeter of blobs
    # on grayscale it isoltes bright region perimeters
    it "should perform a gradient" do
      dest = cvMat.morphology(CV_MOP_GRADIENT)
    end

    it "should perform gradient with more specific arguments" do
      dest = cvMat.morphology(CV_MOP_GRADIENT,
                              kernel,       # specify a kernel (use nil for default)
                              1)            # number of times to perform operation
    end

    # tophat(src) = src-open(src)
    # isolte patches that are brighter than neighbors
    it "should perform a gradient" do
      dest = cvMat.morphology(CV_MOP_TOPHAT)
    end

    it "should perform gradient with more specific arguments" do
      dest = cvMat.morphology(CV_MOP_TOPHAT,
                              kernel,       # specify a kernel (use nil for default)
                              1)            # number of times to perform operation
    end

    # blackhat(src) = close(src)-src
    # isolte patches that are dimmer than neighbors
    it "should perform a gradient" do
      dest = cvMat.morphology(CV_MOP_BLACKHAT)
    end

    it "should perform gradient with more specific arguments" do
      dest = cvMat.morphology(CV_MOP_BLACKHAT,
                              kernel,       # specify a kernel (use nil for default)
                              1)            # number of times to perform operation
    end
  end

  describe "flood fill" do
    # opencv's flood fill takes in a seed point, and all similar (not necessarily identical)
    # neighboring points are filled with a uniform color
    # a pixel will be colorized if its intensity is NOT less than a colorized neighbor - loDiff
    # and is NOT greater than a colorized neighbor + upDiff
    # cvConnectedMap holds statistics about the flood fill
    # flags controls the connectivity ofthe fill
    #    must be an 8-bit image whose size is exactly 2 pixels larger in width and height
    #    its too complicated for me to understand right now
    # i dont know how to get it to work
    it "should do a flood fill" do
      # seed_point = CvPoint.new(0,0)
      # color = CvScalar.new(230,0,0,0) 
      # lo_diff = CvScalar.new(220,0,0,0)
      # hi_diff = CvScalar.new(255,0,0,0)

      # dest = cvMat.flood_fill(seed_point,color,nil,nil)
    end
  end
end