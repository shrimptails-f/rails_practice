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

    test '#search_by_keyword returns matched users' do
      keyword = 'test'
      dummy_results = [OpenStruct.new(name: 'Tester')]
      @mock_repository.expect :search_by_keyword, dummy_results, [keyword]

      assert_equal dummy_results, @service.search_by_keyword(keyword)
      @mock_repository.verify
    end
  end
end
