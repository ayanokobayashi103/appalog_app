require 'rails_helper'
RSpec.describe 'User', type: :system do
  before do
    FactoryBot.create(:user)
  end
  describe 'ユーザ登録のテスト' do
    context 'ユーザの新規登録ができること' do
      it 'noticeが表示される' do
        visit new_user_registration_path
        fill_in 'user[name]', with:'name'
        fill_in 'user[email]', with:'email@e.com'
        fill_in 'user[password]', with:'password'
        fill_in 'user[password_confirmation]', with:'password'
        click_on 'アカウント登録'
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end
  end

  describe 'セッション機能のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with:'user@u.com'
      fill_in 'user[password]', with:'userpass1'
      click_button 'ログイン'
    end
    context 'ログインができること' do
      it 'ログインページに遷移' do
        expect(page).to have_content 'ログインしました!'
      end
    end
    context '自分の詳細画面(マイページ)に飛べること' do
      it 'マイページが表示される' do
        visit root_path
        click_link 'マイページ'
        expect(page).to have_content 'user1さんのページ'
        expect(page).to have_content 'フォロー中'
      end
    end
    context '自分の詳細ページからクチコミ履歴が見れる' do
      it 'クチコミ一覧画面が表示' do
        visit root_path
        click_link 'マイページ'
        click_on 'クチコミ投稿履歴をみる'
        expect(page).to have_content 'user1さんのクチコミ履歴'
      end
    end
    context '他人の詳細画面に飛べるがフォロー者は見れない' do
      it '他人のマイページが見れる' do
        user2 = FactoryBot.create(:user2)
        visit user_path(user2)
        expect(page).to have_content 'user2さんのページ'
        expect(page).not_to have_content 'フォロー中'
      end
    end
    context '店主のページに飛べないこと' do
      it 'ログイン画面へ飛ばされる' do
        owner = FactoryBot.create(:owner)
        visit owner_path(owner)
        expect(page).to have_content 'ログインしてください'
      end
    end
    context 'ログアウトができること' do
      it 'ログアウトしたことがわかる表示が出る' do
        visit root_path
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました!'
      end
    end
  end

  # describe 'フォロー機能のテスト' do
  #   before do
  #     visit new_user_session_path
  #     fill_in 'user[email]', with:'user@u.com'
  #     fill_in 'user[password]', with:'userpass1'
  #     click_button 'ログイン'
  #     FactoryBot.create(:shop)
  #
  #   end
  #   context 'フォローしている人のクチコミ履歴ページをみれる' do
  #     it 'フォロー者のクチコミ一覧画面が表示' do
  #       user2 = FactoryBot.create(:user2)
  #       visit user_path(user2)
  #       click_on 'クチコミ投稿履歴をみる'
  #       expect(page).to have_content 'user2さんのクチコミ履歴'
  #     end
  #   end
  # end
end
