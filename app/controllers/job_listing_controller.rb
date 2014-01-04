class JobListingController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @departments = params.has_key?(:job_listing)? params[:job_listing][:department] : nil
    @job_listings = JobListing.filter(@departments).search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  def sort_column
      JobListing.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end  
end
