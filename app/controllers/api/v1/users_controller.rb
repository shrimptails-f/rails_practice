# frozen_string_literal: true

# API V1のUsersコントローラー
module Api
  module V1
    # ユーザー機能を提供します。
    class UsersController < ApplicationController
      def index
        render json: User.all
      end
    end
  end
end
