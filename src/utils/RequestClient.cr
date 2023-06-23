require "http/client"
require "json"

BASEURL = "https://rickandmortyapi.com/api/"
BASEURL_GRAPHQL = "https://rickandmortyapi.com/graphql"

class RestClient < HTTP::Client
  def get(url)
    response = HTTP::Client.get url
    return response
  end

  def self.getLocation(id)
    ready_url = "#{BASEURL}location/#{id}"
    response = HTTP::Client.get ready_url

    return response
  end

  def self.getCharacter(id)
    ready_url = "#{BASEURL}character/#{id}"
    response = HTTP::Client.get ready_url

    return response
  end

  def self.getEpisode(id)
    ready_url = "#{BASEURL}episode/#{id}"
    response = HTTP::Client.get ready_url

    return response
  end
end

class GraphqlClient < HTTP::Client
  # id = 0, return null
  def self.get(id_location = 0, id_character = 0)
    query = "\"query\": \"{ location (id: #{id_location}) { id name type dimension residents { id } }, character ( id: #{id_character}) { episode { id } } }\""

    response = HTTP::Client.post(BASEURL_GRAPHQL, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: "{ #{query} }")
        
    return JSON.parse(response.body)
  end
end