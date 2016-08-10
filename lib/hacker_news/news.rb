require 'nokogiri'

class HackerNews::News

   attr_accessor :title, :source, :source_url, :rating, :comment_url
   @@all = []

   def initialize(attributes = nil)
     if attributes
       attributes.each {|key, value| self.send(("#{key}="), value)}
    end
     @@all << self
   end


   def self.today
     # Scrape woot and meh and then return deals based on that data
     self.scrape_hacker_news
   end

  #  def self.scrape_news
  #   news = []
  #   news << self.scrape_hacker_news
  #   news
  #  end

  def self.scrape_hacker_news

      doc = Nokogiri::HTML(open("https://news.ycombinator.com/news"))
      @array = []

      doc.search("tr.athing").each do |article|
        attribute = Hash.new


        # TASK: I want a new News instance to be initialized like this:
        # HackerNews::News.new(attributes)
        # (self.new(attributes))

        # attribute[:title] = article.search(" a").text.strip
        attribute[:title] = article.search(" a.storylink").text
        # news_article.title = article.search(" a").text.strip
        attribute[:source_url] = article.search("td.title a").attr('href').value
        # news_article. = article.search("td.title a").attr('href').value
        attribute[:source] =  article.search("span.sitestr").text
        # news_article.source =  article.search("span.sitestr").text
        news_article = self.new(attribute)


        @array << news_article
      end

     doc.search("td.subtext").each_with_index do |article, i|
        #  binding.pry

         if article.search("span.score").text.split("").count > 1
           @array[i].rating = article.search("span.score").text
         else
           @array[i].rating = "0 points"
         end
    end

    doc.search("span.age a").each_with_index do |article, i|
          @array[i].comment_url = article.attr('href')
    end


      @array

   end


   def self.sort

    sorted_array = []
    temp_array = @array
    while sorted_array.count < 30
    max = 0
    temp_news = self.new
    temp_array_2 = temp_array
    # binding.pry
      temp_array_2.each do |article|

        if article.rating.scan(/\d+/).first.to_i >= max
          max = article.rating.scan(/\d+/).first.to_i
          temp_news = article
        end
      end
    temp_array.delete(temp_news)
    sorted_array << temp_news
  end
   sorted_array
  end

end
