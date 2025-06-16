# test/services/contractor/users_service_test.rb
# frozen_string_literal: true

require 'minitest/mock'
require 'test_helper'
require 'ostruct'

module Contractor
  class UsersServiceTest < ActiveSupport::TestCase
    def setup
      @mock_repository = Minitest::Mock.new
      @service = Contractor::UsersService.new(@mock_repository)
    end

    test '#users returns all users from the repository' do
      dummy_users = [OpenStruct.new(name: 'Alice'), OpenStruct.new(name: 'Bob')]
      @mock_repository.expect :all, dummy_users

      assert_equal dummy_users, @service.users
      @mock_repository.verify
    end

    test 'find returns matched user' do
      id = 1
      name = '田中太郎'
      email = 'tanaka@example.com'
      dummy_user = User.new(id: id, name: name, email: email)

      mock_repo = Class.new do
        # 引数の検証を可能にする宣言だが、今回はしてないので不要
        # attr_reader :received_args

        # userにdummy_userが入る。
        define_method(:initialize) do |user|
          # インスタンス変数にすることで、テスト内のスコープで使用可能にする
          @user = user
        end

        def find(id:)
          @received_args = { id: id }
          @user
        end
      end.new(dummy_user)

      service = Contractor::UsersService.new(mock_repo)
      result = service.find(id: id)

      assert_equal dummy_user.name, result.name
      assert_equal dummy_user.email, result.email
    end

    test 'update users' do
      id = 1
      name = '田中太郎'
      email = 'tanaka@example.com'
      dummy_user = User.new(id: id, name: name, email: email)

      mock_repo = Class.new do
        define_method(:initialize) do |user|
          @user = user
        end

        def find(id:)
          @received_args = { id: id }
          @user
        end

        def update(id:, name:, email:)
          @received_args = { id: id, name: name, email: email }
          @user
        end
      end.new(dummy_user)

      service = Contractor::UsersService.new(mock_repo)
      result = service.update(id: id, name: name, email: email)

      assert_equal dummy_user.name, result.name
      assert_equal dummy_user.email, result.email
    end

    test '#search_by_keyword returns matched users' do
      keyword = 'test'
      dummy_results = [OpenStruct.new(name: 'Tester')]
      @mock_repository.expect :search_by_keyword, dummy_results, [keyword]

      assert_equal dummy_results, @service.search_by_keyword(keyword)
      @mock_repository.verify
    end

    test '#create returns created user from repository' do
      name = 'Test User'
      email = 'test@example.com'

      # Minitest::Mockではなく独自のスタブでキーワード引数対応
      mock_repo = Class.new do
        attr_reader :received_args

        def create(name:, email:)
          @received_args = { name: name, email: email }
          OpenStruct.new(name: name, email: email)
        end
      end.new

      service = Contractor::UsersService.new(mock_repo)
      result = service.create(name: name, email: email)

      assert_equal 'Test User', result.name
      assert_equal 'test@example.com', result.email
      assert_equal({ name: name, email: email }, mock_repo.received_args)
      @mock_repository.verify
    end
  end
end
