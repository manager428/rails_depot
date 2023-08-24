require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products # load the fixtures from test/fixtures/products.yml
  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any? # check if the product object has any errors on the title field
    assert product.errors[:description].any? # check if the product object has any errors on the description field
    assert product.errors[:price].any? # check if the product object has any errors on the price field
    assert product.errors[:image_url].any? # check if the product object has any errors on the image_url field
  end

  test 'product price must be positive' do
    product = Product.new(
      title: 'My Book Title',
      description: 'yyy',
      image_url: 'zzz.jpg'
    )
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0 # set the price to 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
      title: 'My Book Title',
      description: 'yyy',
      price: 1,
      image_url:
    )
  end
  test 'image url' do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif] # %w{...} is a shortcut for an array of strings
    bad = %w[fred.doc fred.gif/more fred.gif.more] # %w{...} is a shortcut for an array of strings
    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} should be valid"
    end
    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} should be invalid"
    end
  end
end
