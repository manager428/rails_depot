#---
# Excerpted from "Agile Web Development with Rails 7",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/rails7 for more book information.
#---
require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 3
    assert_select "h2", "Programming Ruby 1.9"
    assert_select "div", /\$[,\d]+\.\d\d/
  end
end
