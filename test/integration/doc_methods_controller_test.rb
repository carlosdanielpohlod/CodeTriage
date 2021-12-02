require "test_helper"

class DocMethodsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @doc_method = doc_methods(:issue_triage_doc)
    @doc_method.save

    @doc_assig = doc_assignment(:default)
    @doc_assig.save

    @user = users(:schneems)
    @user.save 

    @repo_subs = repo_subscriptions(:schneems_to_triage)
    @repo_subs.update_attribute(:id, @user.id)
    @repo_subs.update_attribute(:repo, @doc_method.repo)
    @repo_subs.save

    @doc_assig.update_attribute(:doc_method_id, @doc_method.id)
    @doc_assig.update_attribute(:repo_subscription_id, @repo_subs.id)
    @doc_assig.save
  end
  
  test "GET show" do
    get doc_method_path(id: @doc_method.id)
    assert_response :success
  end

  test "click_source_redirect should redirect to Github" do
    get "/doc_methods/#{@doc_method.id}/users/#{@user.id}/source_click"
    assert_redirected_to DocMethod.find(@doc_method.id).to_github
  end
  #https://github.com/codetriage/CodeTriage/issues/1598
  # test "click_source_redirect should redirect to root page without an correct associated user" do
  #   user_unrelated_with_doc_method = users(:mockstar)
  #   get "/doc_methods/#{@doc_method.id}/users/#{user_unrelated_with_doc_method.id}/source_click"
  #   assert_redirected_to :root
  # end
  
  test "click_method_redirect should redirect to Github" do
    get "/doc_methods/#{@doc_method.id}/users/#{@user.id}/click"
    assert_redirected_to doc_method_url(DocMethod.find(@doc_method.id))
  end

end
