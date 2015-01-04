require 'rails_helper'
require 'cancan/matchers'
require 'support/abilities_helper'

describe Canard::Abilities, 'for :admin' do
  include AbilitiesHelper

  let(:user) { create(:user, :as_admin) }
  subject { Ability.new(user) }

  describe 'god mode' do

    it { can([:read, :create, :destroy, :update, :manage], :all) }

    # You then need to check every object
    # The above line is checking if (can :manage, :all) is present,
    # But it could be followed by a (cannot :manage, User) for example, so all must be checked
    it { can([:metrics, :read, :create, :destroy, :update, :manage], any(:user_group)) }
    it { can([:toggle_finish, :read, :create, :destroy, :update, :manage], any(:grocery)) }
    it { can([:auto_complete, :add, :remove, :read, :create, :destroy, :update, :manage], any(:item)) }
    it { can([:auto_complte, :activate, :read, :create, :destroy, :update, :manage], any(:user)) }
  end
end