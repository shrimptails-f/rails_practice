# app/services/users_service.rb
# frozen_string_literal: true

# サービスのインターフェースです
class UserServiceInterface
  def users
    raise NotImplementedError, "#{self.class} must implement `users` method"
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
  # ユーザーサービス
  class UsersService < UserServiceInterface
    def initialize(user_repository)
      super()
      @user_repository = user_repository
    end

    def users
      @user_repository.all
    end

    def create(name:, email:)
      @user_repository.create(name: name, email: email)
    end

    def find(id:)
      user = @user_repository.find(id: id)
      raise ActiveRecord::RecordNotFound, 'User not found' if user.blank?

      user
    end

    def update(id:, name:, email:)
      user = @user_repository.find(id: id)
      raise ActiveRecord::RecordNotFound, 'User not found' if user.blank?

      @user_repository.update(id: id, name: name, email: email)
    end

    delegate :search_by_keyword, to: :@user_repository
  end
end
