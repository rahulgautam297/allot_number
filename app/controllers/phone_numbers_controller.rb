class PhoneNumbersController < ApplicationController

  def allot_number
    @phone_number = PhoneNumber.new
    @phone_number.allot_number(nil)
    if @phone_number.save
      render json: @phone_number.number
    else
      render json: @phone_number.errors
    end
  end

  def allot_custom_number
    @phone_number = PhoneNumber.new
    @phone_number.allot_custom_number(phone_number_params[:number])
    if @phone_number.save
      render json: @phone_number.number
    else
      render json: @phone_number.errors
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_number_params
      params.permit(:number)
    end
end
