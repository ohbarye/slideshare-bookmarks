require 'nokogiri'
require 'open-uri'
require 'json'
require 'debug'

url = "https://b.hatena.ne.jp/site/speakerdeck.com/ohbarye"
html = URI.open(url).read
doc = Nokogiri::HTML(html)
items = doc.css('.entrylist-contents').map do |item|
  title = item.css('.entrylist-contents-title').text.strip.gsub(/\u2028/, '')
  url = item.css('.entrylist-contents-title a').attr('href').value
  bookmarks = Integer(item.css('.entrylist-contents-users span').text.strip)
  category = item.css('.entrylist-contents-category').text.strip
  date = item.css('.entrylist-contents-date').text.strip
  tags = item.css('ul.entrylist-contents-tags > li').map{ it.text.strip }.sort
  {
    title:,
    url:,
    bookmarks:,
    category:,
    date:,
    tags:,
  }
end.sort_by{ |item| -item[:bookmarks] }

File.write('bookmarks.json', JSON.pretty_generate(items))
