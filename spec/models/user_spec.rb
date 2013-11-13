require 'spec_helper'

describe User do
  [:username, :email, :password, :password_confirmation].each do |attribute|
      it { should allow_mass_assignment_of(attribute) }
  end
  
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }  
  it { should allow_value("email@addresse.foo").for(:email) }
  it { should_not allow_value("foo").for(:email) }  
  it { should_not allow_value("addresse.foo").for(:email) }
  it { should_not allow_value("@addresse.foo").for(:email) }
  it { should validate_confirmation_of(:password) }  
  it { should ensure_length_of(:password).is_at_least(8) }
  it { should ensure_length_of(:password).is_at_most(128) }
end