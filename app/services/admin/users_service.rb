# app/services/users_service.rb
# frozen_string_literal: true

# Admin
module Admin
  # ユーザーサービス
  class UsersService
    def initialize(user_repository)
      @user_repository = user_repository
    end

    def users
      @user_repository.all
    end
  end
end
