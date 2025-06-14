# app/repositories/user_repository.rb
# frozen_string_literal: true

# ユーザーのインターフェース
class UserRepositoryInterface
  def all
    raise NotImplementedError, "#{self.class} must implement `all` method"
  end

  def create(name:, email:)
    raise NotImplementedError, "#{self.class} must implement `create` method"
  end

  def search_by_keyword(keyword)
    raise NotImplementedError, "#{self.class} must implement `search_by_keyword` method"
  end
end

module Contractor
  # ユーザーのリポジトリ
  class UserRepository < UserRepositoryInterface
    delegate :all, to: :'::User'

    def create(name:, email:)
      ::User.create(name: name, email: email)
    end

    def search_by_keyword(keyword)
      ::User.where('name LIKE ?', "%#{keyword}%")
    end
  end
end
