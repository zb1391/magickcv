
require './magick_cv'
include MagickCv

describe "Opening an Image from a URL" do
  it "should create an image with the right dimensions" do
    image = nil
    # image has dimensions 500 x 375
    open('http://www.downtownsports.org/assets/court1-2385161e2e1066fcb871ef06b9408905.jpg', 'rb') do |f|
      image = Magick::Image::from_blob(f.read).first
    end
    expect(image.rows).to eq(375)
    expect(image.columns).to eq(500)
  end

  it "should return a CvMat Object with proper dimensions" do
    cvMat = mat_from_url('http://www.downtownsports.org/assets/court1-2385161e2e1066fcb871ef06b9408905.jpg')
    expect(cvMat.class).to eq(CvMat)
    expect(cvMat.rows).to eq(375)
    expect(cvMat.columns).to eq(500)
  end
end