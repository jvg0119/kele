
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

  def get_me
    response = Kele.get(api_endpoint("/users/me"), headers: {"authorization" => @auth_token} )
    user = JSON.parse(response.body)

    # user.each do |key, val|
    #   p "#{key} : #{val}"
    # end
  end

  def get_mentor_availability(mentor_id) #1994246
    response = self.class.get(api_endpoint("/mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @auth_token} )
    mentor_availability = JSON.parse(response.body)

    # puts "================================="
    # mentor_availability.each do |availability|
    #   p availability
    # end
  end

  private

  def api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end

end
