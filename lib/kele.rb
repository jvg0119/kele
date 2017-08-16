
require 'httparty'
require 'json'

class Kele
  include HTTParty

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_endpoint("sessions"), body: {"email": email, "password": password} )

    if (response.code == 200) && response['auth_token']
      puts "All good!"
    else
      puts "Email or password was incorrect"
    end

    @auth_token = response['auth_token']

      # puts response.code
      # puts response.message
      # puts response.body
      # puts response.code
  end

  private

  def api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end

end
