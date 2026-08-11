# frozen_string_literal: true

module Foundation
  module Storefront
    class OrdersController < BaseController
      def index
        return redirect_to new_user_session_path, alert: "Sign in to view your past orders." unless user_signed_in?

        @orders = Order.includes(:line_items)
          .where(user: current_user)
          .order(created_at: :desc)
          .limit(50)
      end

      def show
        @order = Order.includes(:line_items).find_by!(public_reference: params[:id])
        head :not_found unless ReceiptAccess.allowed?(order: @order, user: current_user, token: params[:access_token])
      end
    end
  end
end
