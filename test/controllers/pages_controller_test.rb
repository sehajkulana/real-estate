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
end
