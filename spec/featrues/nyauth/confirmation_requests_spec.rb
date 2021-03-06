require 'rails_helper'

RSpec.describe 'Nyauth::ConfirmationRequests' do
  let!(:user) { create(:user) }

  feature 'confirmation' do
    background do
      visit nyauth.new_confirmation_request_path
    end

    scenario 'request & confirm' do
      fill_in('user_email', with: user.email)
      click_button('request confirmation')

      open_email(user.email)
      current_email.click_link('confirm')

      expect(page).to have_content('confirmed')
      user.reload
      expect(user).to be_confirmed
    end

    scenario 'request expired' do
      fill_in('user_email', with: user.email)
      click_button('request confirmation')

      Timecop.freeze(Time.current + 3.hours) do
        open_email(user.email)
        current_email.click_link('confirm')

        expect(page).to have_content('expired')
      end
    end
  end
end
