require File.join(File.dirname(__FILE__), '../../', 'application_controller')
require_relative '../../../models/job'

module Api
  module V1
    class JobsController < ApplicationController
      before_action 'authenticate', actions: %w[index show]

      def index
        render json: Job.all, status: 200
      end

      def show
        job = Job.find(id: params[:id])
        return render json: { message: 'Job not found' }, status: 404 if job.nil?

        render json: job, status: 200
      end
    end
  end
end
