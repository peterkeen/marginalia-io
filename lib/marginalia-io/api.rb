require 'rubygems'
require 'httparty'
require 'netrc'
require 'uri'

module Marginalia
  module IO

    class NetRCMissingError < StandardError; end

    class API

      include HTTParty

      def initialize(host='www.marginalia.io')
        credentials = Marginalia::IO::Auth.new(host).get_credentials
        self.class.base_uri "https://#{host}"
        self.class.basic_auth credentials[0], credentials[1]
      end

      def append(id, body)
        self.class.post("/notes/#{id}/append.json", :body => {:body => body})
      end

      def create(title, body)
        self.class.post("/notes.json", :body => {:note => {:body => body, :title => title}})
      end

      def all
        self.class.get("/notes.json").parsed_response
      end

      def search(query)
        escaped = URI.escape(query)
        self.class.get("/notes/search.json?q=#{escaped}").parsed_response
      end

      def get(id)
        self.class.get("/notes/#{id}.json")
      end

      def update(id, body)
        puts self.class.put("/notes/#{id}.json", :body => {:note => {:body => body}}).parsed_response
      end
    end

  end
end
