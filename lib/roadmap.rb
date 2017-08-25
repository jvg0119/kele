
require 'httparty'

module Roadmap

  def get_roadmap(roadmap_id ) # id for the Rails roadmaps is 31, 40 "Full Stack Track"
    response = self.class.get(api_endpoint("/roadmaps/#{roadmap_id}"), headers: {"authorization" => @auth_token} )
    roadmap_body = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id) # Retrieve checkpoints from  roadmap  ex: 1615, 1616 ...
    response = Kele.get(api_endpoint("/checkpoints/#{checkpoint_id}"), headers: {"authorization" => @auth_token} )
    checkpoint_body = JSON.parse(response.body)
  end
  # self.class   same as   Kele (the name of the module or class)

end
