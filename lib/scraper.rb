require 'nokogiri'
require 'open-uri'
require 'pry'

html=open('https://learn-co-curriculum.github.io/student-scraper-test-page/index.html')
doc=Nokogiri::HTML(html)

class Scraper

  def self.scrape_index_page(index_url)
    html=open(index_url)
    doc=Nokogiri::HTML(html)
    
    ret_array=[]
    doc.css(".student-card").each do |student|
      ret_array << {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    ret_array

  end

  def self.scrape_profile_page(profile_url)
    html=open(profile_url)
    doc=Nokogiri::HTML(html)

    #binding.pry
    ret_hash={
      :profile_quote => doc.css(".vitals-text-container div.profile-quote")[0].text,
      :bio => doc.css("div.bio-content.content-holder div.description-holder")[0].text.strip
    }

    doc.css(".social-icon-container a").each do |a|
      if a.attr("href").include?"twitter"
        ret_hash[:twitter]=a.attr("href")
      elsif a.attr("href").include?"linkedin"
        ret_hash[:linkedin]=a.attr("href")
      elsif a.attr("href").include?"github"
        ret_hash[:github]=a.attr("href")
      else
        ret_hash[:blog]=a.attr("href")
      end
    end

    ret_hash

  end

end

