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
