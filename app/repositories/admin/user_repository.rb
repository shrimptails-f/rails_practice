# app/repositories/user_repository.rb
# frozen_string_literal: true

# ユーザーのインターフェース
class UserRepositoryInterface
  def all
    raise NotImplementedError, "#{self.class} must implement `all` method"
  end
end

module Admin
  # ユーザーのリポジトリ
  class UserRepository < UserRepositoryInterface
    def all
      ::User.all
    end
  end
end
