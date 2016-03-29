class PagesController < ApplicationController
  def main

  end

  def send_contact_email
    name = contact_params[:name]
    email = contact_params[:email]
    body = contact_params[:comments]

    PageMailer.contact_email(name, email, body).deliver
    redirect_to pages_main_path
  end

  private
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end
