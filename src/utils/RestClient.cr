require "http/client"

BASEURL = "https://rickandmortyapi.com/api/"

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
