require_relative '../../application_controller'
require_relative '../../../models/product'

module Api
  module V1
    class ProductsController < ApplicationController
      before_action 'authenticate', actions: %w[index show create]

      def index
        render json: Product.all, status: 200
      end

      def show
        product = Product.find(id: params[:id])
        return render json: { message: 'Product not found' }, status: 404 if product.nil?

        render json: product, status: 200
      end

      def create
        product = Product.new(params.slice(*product_params))
        if product.valid?
          job_id = product.create_async
          return render json: { message: 'Failed to queue product creation' }, status: 400 if job_id.nil?

          render json: { message: 'Processing product...', job_id: }, status: 200
        else
          render json: product.errors, status: 422
        end
      end

      private

      def product_params
        %i[name]
      end
    end
  end
end
