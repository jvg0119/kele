
require 'httparty'
require 'json'
require 'roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_endpoint("sessions"), body: {"email": email, "password": password} )
    if (response.code == 200) && response['auth_token']
      puts "All good!"
    else
      puts "Email or password was incorrect"
    end
    @auth_token = response['auth_token']
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

    array = []
    mentor_availability.each do |a|
      a.each do |k,v|
        array << k
        array << v
      end
    end
    return array
   end

  # moved to module
  # def get_roadmap(roadmap_id ) # 31
  #   response = self.class.get(api_endpoint("/roadmaps/#{roadmap_id}"), headers: {"authorization" => @auth_token} )
  #   roadmap_body = JSON.parse(response.body)
  # end
  #
  # def get_checkpoint(checkpoint_id)
  #   response = self.class.get(api_endpoint("/checkpoints/#{checkpoint_id}"), headers: {"authorization" => @auth_token} )
  #   checkpoint_body = JSON.parse(response.body)
  # end

  def get_messages(*page) # passing an array w/ the splat operator
    if page == [] # if array is empty do this
      response = Kele.get(
        api_endpoint("/message_threads"),
        headers: { "authorization" => @auth_token }
      )
    else
      response = Kele.get(
        api_endpoint("/message_threads?page=#{page[0]}"),   # array is not empty select the first element
        # below are OK; it's basically passing the first element in the array w/c is same as page[0]
        # api_endpoint("/message_threads?page=#{page.first}"),
        # api_endpoint("/message_threads?page=#{page.last}"),
        headers: { "authorization" => @auth_token }
      )
    end
      messages = JSON.parse(response.body)
      #response.code
  end
  # self.class   same as   Kele (the name of the module or class)

  def create_message(sender_email, recipient_id, token, message_subject, message_body)
    response = Kele.post(api_endpoint("messages"), headers: { "authorization" => @auth_token },
      #body {
      query: {
        sender: sender_email,
        recipient_id: recipient_id,
        token: token,
        subject: message_subject,
        "stripped-text": message_body
      })
      #response.code
  end



  private

  def api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end

end
