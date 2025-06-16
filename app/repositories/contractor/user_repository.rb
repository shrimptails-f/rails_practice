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

  def find(id)
    raise NotImplementedError, "#{self.class} must implement `find` method"
  end

  def update(id, name:, email:)
    raise NotImplementedError, "#{self.class} must implement `update` method"
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

    def find(id:)
      ::User.find(id)
    end

    def update(id:, name:, email:)
      ::User.where(id: id).update(name: name, email: email)
    end
  end
end
