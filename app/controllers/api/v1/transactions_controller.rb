module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :authenticate_request
      before_action :set_transaction, only: [:show]

      def index
        @transactions = current_user.transactions.order(created_at: :desc)
        render json: @transactions
      end

      def show
        render json: @transaction
      end

      def create
        @transaction = current_user.transactions.build(transaction_params)
        
        if @transaction.save
          render json: @transaction, status: :created
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_transaction
        @transaction = current_user.transactions.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Transaction not found" }, status: :not_found
      end

      def transaction_params
        params.require(:transaction).permit(:amount, :transaction_type, :description, :status)
      end
    end
  end
end