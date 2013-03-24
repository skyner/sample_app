require 'spec_helper'

describe RelationshipsController do
	
	let(:user) { FactoryGirl.create(:user, email: 'wp@wp2.pl') }
	let(:other_user) { FactoryGirl.create(:user, email: 'wp@wp.pl') }

	before { sign_in user }

	describe "creating a relationship with Ajax" do

		it "should increment the Relationship count" do
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.to change(Relationship, :count).by(1)
		end

		it "should respond with success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			response.should be_success
		end
	end

	describe "destroy a relationship with Ajax" do
		before { user.follow!(other_user) }
		let(:relationship) { user.relationships.find_by_followed_id(other_user) }

		it "should decrement the Relationship count" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)
		end

		it "should respond with success" do
			xhr :delete, :destroy, id: relationship.id
			response.should be_success
		end
	end
end