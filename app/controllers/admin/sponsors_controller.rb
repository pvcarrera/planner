class Admin::SponsorsController < Admin::ApplicationController

  before_filter :set_sponsor, only: [ :show, :edit, :update]

  def index
    @sponsors = Sponsor.joins(:sponsor_sessions).all
  end

  def new
    @sponsor = Sponsor.new
    @sponsor.build_address
    authorize @sponsor
  end

  def create
    @sponsor = Sponsor.new(sponsor_params)
    authorize @sponsor
    @sponsor.build_address unless @sponsor.address.present?
    if @sponsor.save
      flash[:notice] = "Sponsor #{@sponsor.name} created"
      redirect_to [:admin, @sponsor]
    else
      flash[:notice] = @sponsor.errors.full_messages.to_s
      render 'new'
    end
  end

  def update
    @sponsor.update_attributes(sponsor_params)

    redirect_to admin_sponsor_path(@sponsor), notice: "Updated!"
  end

  private
  def sponsor_params
    params.require(:sponsor).permit(:name, :avatar, :website, :seats, :number_of_coaches, address_attributes: [:flat, :street, :postal_code, :city])
  end

  def set_sponsor
    @sponsor = Sponsor.find(params[:id])
    authorize @sponsor
  end
end
