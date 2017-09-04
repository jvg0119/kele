
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


  # def create_message(sender_email, recipient_id, token, message_subject, message_body)
  #   response = Kele.post(api_endpoint("messages"), headers: { "authorization" => @auth_token },
  #     #body: {
  #     query: {
  #       sender: sender_email,
  #       recipient_id: recipient_id,
  #       token: token,
  #       subject: message_subject,
  #       "stripped-text": message_body
  #     })
  #     #response.code
  # end

  # def create_message2(sender_email, recipient_id, message_subject, message_body)
  #   response = Kele.post(api_endpoint("messages"), headers: { "authorization" => @auth_token },
  #     body: {
  #     #query: {
  #       sender: sender_email,
  #       recipient_id: recipient_id,
  #       #token: token,
  #       subject: message_subject,
  #       "stripped-text": message_body
  #     })
  #     #response.code
  # end

  def create_message(sender_email, recipient_id, token=nil, message_subject, message_body)
    if token
        options = {
          sender: sender_email,
          recipient_id: recipient_id,
          token: token,
          subject: message_subject,
          "stripped-text": message_body
        }
    else
      options = {
          sender: sender_email,
          recipient_id: recipient_id,
          subject: message_subject,
          "stripped-text": message_body
        }
    end
    response = Kele.post(api_endpoint("messages"), headers: { "authorization" => @auth_token }, query: options )
      #response.code
  end

  def create_submissions(checkpoint_id, assignment_branch, assignment_commit_link, comment, student_enrollment_id)
  response = self.class.post(api_endpoint("checkpoint_submissions"), headers: { "authorization" => @auth_token },
  query: {
    "assignment_branch": assignment_branch, #"assignment-22-iterative-search",
    "assignment_commit_link": assignment_commit_link, # "https":/github.com/me/repo/commit/5",
    "checkpoint_id": checkpoint_id, # 1635,
    "comment": comment, # "this is my work",
    "enrollment_id": student_enrollment_id  # 11218,  28114
    })
     response.code
end

# this worked
# "assignment_branch": "assignment-46-pirvate-topics",
# "assignment_commit_link": "https://github.com/jvg0119/bloccit_iv/tree/assign-46-private-topics",
# "checkpoint_id": 1657,
# "comment": "this is my comment work",
# "enrollment_id": 28114 #    this is my id:

  private

  def api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end

end
