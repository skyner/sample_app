require 'spec_helper'

describe Micropost do
	let( :user ) { FactoryGirl.create(:user) }
	before { @micropost = user.microposts.build( content: "Lorem ipsum" ) }

	subject{ @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }

	it { should be_valid }

	describe "accsessible attributes" do
		it "should not allow to accsess to user_id" do
			expect do
				Micropost.new( user_id: user.id )
			end.to raise_error( ActiveModel::MassAssignmentSecurity::Error )
		end
	end

	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "with content too long" do
		before { @micropost.content = "1" * 141 }
		it{ should_not be_valid }
	end
end