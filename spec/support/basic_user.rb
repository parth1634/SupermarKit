# Logs in a "basic user", a typical scenario where someone has a kit with groceries and items
shared_context 'basic user' do
  let(:grocery) { controller.current_user.user_groups.first.groceries.first }
  let(:user_group) { controller.current_user.user_groups.first }
  before(:each) do
    @user = create(:user, :full_user)
    @user.activate!
    login_user
  end
end
