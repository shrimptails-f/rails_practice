# test/controllers/api/v1/users_controller_test.rb
# frozen_string_literal: true

require 'minitest/mock'
require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      test 'should get index with mocked service' do
        mock_user = Minitest::Mock.new
        def mock_user.as_json(*)
          { id: 1, name: 'Taro', email: 'taro@example.com' }
        end

        mock_service = Minitest::Mock.new
        mock_service.expect :users, [mock_user]

        Contractor::UsersService.stub :new, mock_service do
          get '/api/v1/users'
          assert_response :success

          json = JSON.parse(response.body)
          assert_equal 1, json.length
          assert_equal 'Taro', json.first['name']
        end

        mock_service.verify
      end

      test 'should get search result with mocked service' do
        keyword = 'Taro'

        mock_user = Minitest::Mock.new
        def mock_user.as_json(*)
          { id: 1, name: 'Taro', email: 'taro@example.com' }
        end

        mock_service = Minitest::Mock.new
        mock_service.expect :search_by_keyword, [mock_user], [keyword]

        Contractor::UsersService.stub :new, mock_service do
          get '/api/v1/users/search', params: { keyword: keyword }
          assert_response :success

          json = JSON.parse(response.body)
          assert_equal 1, json.length
          assert_equal 'Taro', json.first['name']
        end

        mock_service.verify
      end

      test 'should show user' do
        id = 12_345
        name = '田中太郎'
        email = 'tanaka@example.com'
        dummy_user = User.new(id: id, name: name, email: email)

        mock_repo = Class.new do
          define_method(:initialize) do |user|
            @user = user
          end

          def find(id:)
            @received_args = { id: id }
            raise ActiveRecord::RecordNotFound, 'User not found' if id != @user.id

            @user
          end
        end.new(dummy_user)

        Contractor::UserRepository.stub :new, mock_repo do
          get '/api/v1/users/12345', params: {}

          assert_response :success
        end
      end

      test 'should fail find user when not found' do
        id = 1
        name = '田中太郎'
        email = 'tanaka@example.com'
        dummy_user = User.new(id: id, name: name, email: email)

        mock_repo = Class.new do
          define_method(:initialize) do |user|
            @user = user
          end

          def find(*)
            nil # ユーザーが見つからないことを表現
          end
        end.new(dummy_user)

        Contractor::UserRepository.stub :new, mock_repo do
          get '/api/v1/users/12345', params: {}

          assert_response :not_found
          json = JSON.parse(response.body)
          assert_equal 'User not found', json['error']
        end
      end

      test 'should update user' do
        id = 123
        name = '田中太郎'
        email = 'tanaka@example.com'
        dummy_user = User.new(id: id, name: name, email: email)

        mock_service = Class.new do
          define_method(:initialize) do |user|
            @user = user
          end

          def find(id:)
            @received_args = { id: id }
            raise ActiveRecord::RecordNotFound, 'User not found' if id != @user.id

            @user
          end

          def update(id:, name:, email:)
            @received_args = { id: id, name: name, email: email }
            @user
          end
        end.new(dummy_user)

        Contractor::UsersService.stub :new, mock_service do
          patch '/api/v1/users/123', params: {
            name: 'Test User',
            email: 'test@example.com'
          }

          assert_response :success
        end
      end

      test 'should fail update user when not found' do
        mock_repo = Class.new do
          def find(*)
            nil # ユーザーが見つからないことを表現
          end

          def update(*)
            raise 'should not be called' # 呼ばれないことを保証
          end
        end.new

        Contractor::UserRepository.stub :new, mock_repo do
          patch '/api/v1/users/999999999999999', params: {
            name: 'Test User',
            email: 'test@example.com'
          }

          assert_response :not_found
          json = JSON.parse(response.body)
          assert_equal 'User not found', json['error']
        end
      end

      test 'should create user' do
        post '/api/v1/users', params: {
          name: 'Test User',
          email: 'test@example.com'
        }

        assert_response :success

        json = JSON.parse(response.body)
        assert_equal 'Test User', json['name']
        assert_equal 'test@example.com', json['email']
      end
    end
  end
end
