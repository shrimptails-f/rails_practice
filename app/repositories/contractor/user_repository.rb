# app/repositories/user_repository.rb
# frozen_string_literal: true

# ユーザーのインターフェース
class UserRepositoryInterface
  def all
    raise NotImplementedError, "#{self.class} must implement `all` method"
  end

  # def search_by_keyword(keyword)
  #   raise NotImplementedError, "#{self.class} must implement `search_by_keyword` method"
  # end
end

module Contractor
  # ユーザーのリポジトリ
  class UserRepository < UserRepositoryInterface
    def all
      ::User.all
    end

    def search_by_keyword(keyword)
      ::User.where('name LIKE ?', "%#{keyword}%")
    end
  end
end
