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
end
