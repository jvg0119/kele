
require 'httparty'
require 'json'
require 'rest_client'

class Kele
  include HTTParty

  base_uri "https://www.bloc.io/api/v1/"

  #attr_accessor :email, :password

  def initialize(email, password)
    #@email = email
    #@password = password
    response_body = self.class.post(base_api_endpoint("sessions"), body: {"email": email, "password": password} )

    puts @auth_token = response_body['auth_token']
  end

  private

  def base_api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end

end
