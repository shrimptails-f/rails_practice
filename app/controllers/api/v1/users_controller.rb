# frozen_string_literal: true

# API V1のUsersコントローラー
module Api
  module V1
    # ユーザー機能を提供します。
    class UsersController < ApplicationController
      def index
        users = ::Contractor::UsersService.new(
          ::Contractor::UserRepository.new
        ).users

        # 管理者の場合の実装例メモ
        # users = ::Admin::UsersService.new(
        #   ::Admin::UserRepository.new
        # ).users
        render json: users
      end

      def create
        user_params = params.permit(:name, :email)
        service = Contractor::UsersService.new(Contractor::UserRepository.new)
        render json: service.create(**user_params.to_h.symbolize_keys)
      end

      # 複数関数がある場合の動作確認
      def search
        service = Contractor::UsersService.new(Contractor::UserRepository.new)
        users = service.search_by_keyword(params[:keyword])

        render json: users
      end
    end
  end
end
