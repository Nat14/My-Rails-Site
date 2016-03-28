class PagesController < ApplicationController
  def main

  end

  def send_contact_email
    name = params[:contact][:name]
    email = params[:contact][:email]
    body = params[:contact][:comments]

    PageMailer.contact_email(name, email, body).deliver
  end

  private
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end
