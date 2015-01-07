class CatRentalRequestsController < ApplicationController

  CATS = Cat.all

  def index
    @cat_rental_requests = CatRentalRequest.all
    render :index
  end

  def new
    @cats = CATS
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url(Cat.find(@cat_rental_request.cat_id))
    else
      puts "Failed, params are #{cat_rental_request_params}"
      @cats = CATS
      render :new
    end
  end

  def approve
    CatRentalRequest.find(params[:id]).approve!
  end

  def deny
    CatRentalRequest.find(params[:id]).deny!
  end

  private
    def cat_rental_request_params
      params[:cat_rental_request].permit(:start_date, :end_date, :cat_id)
    end

end
