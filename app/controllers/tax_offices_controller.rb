class TaxOfficesController < ApplicationController
  before_filter 'authenticate_with_session'

  def index

  end

  def search
    @offices = []
    TaxOffice.search_by_city(params[:city]).each do |to|
      @offices << { id: to.id, name: to.full_name }
    end
    respond_to do |format|
      format.json
    end
  end

  def show
    @tax_office = TaxOffice.where(id: params[:id].to_i).first
    render layout: false
  end

end