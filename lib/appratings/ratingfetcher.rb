require "net/http"
require "openssl"
require "json/ext"
require "nokogiri"

module AppRatings
  class RatingFetcher
    def self.fetch_info(app_id)
      uri = URI("http://itunes.apple.com/lookup?id=#{app_id}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = uri.scheme == 'https' ? true : false
      http.start

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request request

      json = JSON::Ext::Parser.new(response.body)
      json_data = json.parse()

      app = json_data['results'][0]

      app
    end

    def self.fetch_ratings(app_id)
      uri = URI("https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=#{app_id}&pageNumber=0&sortOrdering=2&type=Purple+Software&ign-mscache=1")

      http = Net::HTTP.new(uri.host, uri.port)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = uri.scheme == 'https' ? true : false
      http.start

      request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => 'iTunes/11.0.2 (Macintosh; OS X 10.8.2) AppleWebKit/536.26.14'})

      response = http.request request

      doc = Nokogiri::XML::Document.parse(response.body)

      runs = 0
      total_ratings = Hash.new
      version_ratings = Hash.new

      e = doc.xpath('//xmlns:HBoxView[@rightInset=5]/@alt', {'xmlns' => 'http://www.apple.com/itms/'})
      e.each do |d|
        r = d.to_s.split(',')
        rating = r[0].strip.delete(' stars')
        stars = r[1].strip.delete(' ratings')

        if runs < 5
          total_ratings[rating] = stars
        else
          version_ratings[rating] = stars
        end

        runs += 1
      end

      ratings = Hash.new
      ratings[:total] = total_ratings
      ratings[:version] = version_ratings

      ratings
    end
  end
end
