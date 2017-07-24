require 'rails_helper'
# Specs in this file have access to a helper object that includes
# the EmployeesHelper. For example:
#
# describe EmployeesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  include ActionView::Helpers
  it 'shows nice formatted errors' do
    user = User.new
    user.valid?
    str = helper.show_model_errors(user)
    expect(str).to have_content 'Przepraszamy wystąpiły błędy'
  end

  it 'shows errors for uploader' do
    user = create(:user)
    # company = create(:company, user: user)
    file = Rack::Test::UploadedFile.new('spec/fixtures/invalid.txt', 'text/txt')
    uploader = ZusUploader.new(user, file)

    str = show_uploader_errors(uploader)
    expect(str).to have_content 'Przepraszamy wystąpiły błędy'

  end

end
