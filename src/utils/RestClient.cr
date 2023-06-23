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
  def get(url, id_character = 1, id_location = 1)
    query = {
      character(id: id_character) {
        episode {
          id
        }
      },
      location(id: id_location) {
        id
        name
        type
        dimension
        residents {
          id
        }
      }
    }.to_json

    response = HTTP::Client.post("#{BASEURL_GRAPHQL}", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: "query: #{query}")
    return response
  end
end