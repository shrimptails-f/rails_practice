# app/services/users_service.rb
# frozen_string_literal: true

# サービスのインターフェースです
class UserServiceInterface
  def users
    raise NotImplementedError, "#{self.class} must implement `users` method"
  end

  def search_by_keyword(keyword)
    raise NotImplementedError, "#{self.class} must implement `search_by_keyword` method"
  end
end

module Contractor
  # ユーザーサービス
  class UsersService < UserServiceInterface
    def initialize(user_repository)
      super()
      @user_repository = user_repository
    end

    def users
      @user_repository.all
    end

    # 複数関数がある場合の動作確認
    def search_by_keyword(keyword)
      @user_repository.search_by_keyword(keyword)
    end
  end
end
