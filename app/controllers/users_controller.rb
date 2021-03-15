class UsersController < ApplicationController

  def new_student_registration
    respond_to do |format|
      format.html { render :'users/students/new' }
    end
  end

  def send_request
    ApplicationMailer.send_registration_link(params[:email]).deliver_now
    respond_to do |format|
      format.html { render :'users/students/thank_you' }
    end
  end
end
