require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page renders successfully" do
    get root_path
    assert_response :success
  end

  test "main pages render successfully" do
    [about_path, agent_path, services_path, properties_path, property_path(properties(:one)), blog_path, blog_post_path, contact_path].each do |path|
      get path
      assert_response :success, "expected #{path} to render successfully"
    end
  end

  test "properties are filtered by the searched city" do
    properties(:one).update!(city: "Mumbai", title: "Mumbai property")
    properties(:two).update!(city: "Pune", title: "Pune property")

    get properties_path, params: { city: "mumbai" }

    assert_response :success
    assert_select "input[type=hidden][name=city][value=Mumbai]", count: 1
    assert_select "h3", text: properties(:one).title, count: 1
    assert_select "h3", text: properties(:two).title, count: 0
  end

  test "properties can be filtered by their attributes" do
    properties(:one).update!(
      title: "Matching property", city: "Mumbai", bathrooms: 2, price: 750_000,
      facing: "East", property_type: "Apartment", parking: 1, area: 1_200, listing_type: "For Sale"
    )
    properties(:two).update!(
      title: "Non-matching property", city: "Pune", bathrooms: 1, price: 100_000,
      facing: "West", property_type: "House", parking: 0, area: 400, listing_type: "For Rent"
    )

    get properties_path, params: {
      city: "mum", bathrooms: "2", budget: "500000-1000000", facing: "East",
      property_type: "Apartment", parking: "1", area: "1000-2000", listing_type: "For Sale"
    }

    assert_response :success
    assert_select "h3", text: "Matching property", count: 1
    assert_select "h3", text: "Non-matching property", count: 0
  end

  test "properties page renders a budget range control" do
    get properties_path, params: { budget: "500000-1000000" }

    assert_response :success
    assert_select "select[name=budget]", count: 0
    assert_select "input[type=range][data-budget-range-target=minimum][value=500000]", count: 1
    assert_select "input[type=range][data-budget-range-target=maximum][value=1000000]", count: 1
    assert_select "input[type=hidden][name=budget][value='500000-1000000']", count: 1
  end
end
