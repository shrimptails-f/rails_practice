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

      def show
        id = params[:id]
        service = Contractor::UsersService.new(Contractor::UserRepository.new)
        user = service.find(id: id.to_i)
        render json: { name: user.name, email: user.email }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end

      def update
        user_params = params.permit(:name, :email)
        id = params[:id]

        service = Contractor::UsersService.new(Contractor::UserRepository.new)
        service.update(id: id.to_i, name: user_params[:name], email: user_params[:email])
        render json: {}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end
    end
  end
end
