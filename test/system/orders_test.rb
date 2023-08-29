require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "check dynamic fields" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"

    select "Check", from: "Pay type"

    assert has_field? "Routing number"
    assert has_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"

    select "Credit card", from: "Pay type"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_field? "Credit card number"
    assert has_field? "Expiration date"
    assert has_no_field? "Po number"

    select "Purchase order", from: "Pay type"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_field? "Po number"
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "dave@example.com"

    select "Check", from: "Pay type"
    fill_in "Routing number", with: "123456"
    fill_in "Account number", with: "987654"

    click_button "Place Order"
    assert_text "Thank you for your order"

    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first
    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal "Sam Ruby <depot@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
