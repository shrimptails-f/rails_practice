# /myapp/test/repositories/contractor/user_repository_test.rb
# frozen_string_literal: true

require 'minitest/mock'
require 'test_helper'

module Contractor
  class UserRepositoryTest < ActiveSupport::TestCase
    def setup
      @repository = UserRepository.new
    end

    test 'all returns all users' do
      users = [User.new(name: '山田'), User.new(name: '佐藤')]
      User.stub :all, users do
        result = @repository.all
        assert_equal users, result
      end
    end

    test 'find returns matched users' do
      id = 1
      name = '田中太郎'
      email = 'tanaka@example.com'
      dummy_user = User.new(id: id, name: name, email: email)

      User.stub :find, dummy_user, [{ name: name, email: email }] do
        result = @repository.find(id: id)
        assert_equal dummy_user, result
      end
    end

    test 'search_by_keyword returns matched users' do
      keyword = '田中'
      matched_users = [User.new(name: '田中太郎')]
      User.stub :where, matched_users, ['name LIKE ?', "%#{keyword}%"] do
        result = @repository.search_by_keyword(keyword)
        assert_equal matched_users, result
      end
    end

    test 'create calls User.create with correct parameters' do
      name = '田中太郎'
      email = 'tanaka@example.com'
      dummy_user = User.new(name: name, email: email)

      User.stub :create, dummy_user, [{ name: name, email: email }] do
        result = @repository.create(name: name, email: email)
        assert_equal dummy_user, result
      end
    end
  end
end
