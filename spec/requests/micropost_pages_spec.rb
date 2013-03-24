require 'spec_helper'

describe "MicropostPages" do

	subject { page }

	let(:user){ FactoryGirl.create(:user, email: 'diff@diff.pl') }
	
	before { sign_in user }

	describe "microposts creation" do
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.to change( Micropost, :count ).by(1)
			end
		end
	end

	describe "micropost destruction" do
		before { FactoryGirl.create( :micropost, user: user ) }

		describe "as correct user" do
			before { visit root_path }

			it "should delete a micropost" do
				expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			end
		end
	end

	describe "microposts count for none microposts" do
		before { visit user_path(user) }

		it { should_not have_content( 'Microposts' ) }
	end

	describe "microposts count for one microposts" do
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		before { visit user_path(user) }
		it { should have_content( "Micropost" ) }
	end

	describe "microposts count for more than one microposts" do
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m3) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		before { visit user_path(user) }
		it { should have_content( "Microposts" ) }
	end

	describe "pagination" do 
		before do
			32.times { user.microposts.create!(content: "Lorem ipsum") }
			visit user_path(user)
		end
		
		it { should have_css('div.pagination') }
	end

	describe "should not have delete link on other user" do
		let(:other_user){ FactoryGirl.create(:user, email: "aaa@aa.pl") }
		before do
			32.times { other_user.microposts.create!(content: "Lorem ipsum") }
			visit user_path(other_user)
		end
		it { should_not have_link('delete') }
	end
end
