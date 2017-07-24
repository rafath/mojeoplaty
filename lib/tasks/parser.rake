require 'rubygems'
require 'rake'
require 'nokogiri'
require 'open-uri'
require 'csv'

namespace :parser do

  include ActionView::Helpers::SanitizeHelper


  task :pf => :environment do


    f = File.open("lib/assets/ksiegowi-fp.txt", 'a+')

    (1..290).each do |i|
      link = "http://panoramafirm.pl/biuro_rachunkowe/mazowieckie/firmy,#{i}.html" #290
      # link = "http://panoramafirm.pl/biuro_rachunkowe/pomorskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/wielkopolskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/zachodniopomorskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/zachodniopomorskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/dolno%C5%9Bl%C4%85skie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/%C5%9Bl%C4%85skie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/opolskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/kujawsko-pomorskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/lubelskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/lubuskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/ma%C5%82opolskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/podkarpackie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/%C5%9Bwi%C4%99tokrzyskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/warmi%C5%84sko-mazurskie/firmy,#{i}.html"
      # link = "http://panoramafirm.pl/biuro_rachunkowe/podlaskie/firmy,#{i}.html"
      doc = open(link,
                 "User-Agent" => "Mozilla/7.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)",
                 "Header" => "Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5; Accept-Language: en-us,en;q=0.5; Accept-Charset: utf-8;q=0.7,*;q=0.7",
                 # "Header" => "Keep-Alive: 300",
                 "Referer" => "http://www.google.pl/"
      )

      page = Nokogiri::HTML(doc)
      # page = Nokogiri::HTML(open('lib/assets/pf.html'))
      mails = page.css('a.icon-mail')
      mails.each do |m|
        f << "#{m.text}\n"
        puts m.text
      end
      puts i
      sleep(rand(15..30))
    end
    f.close
  end

  task uniq: :environment do
    f = File.open('lib/assets/ksiegowi-fp.txt')
    fu = File.open('lib/assets/ksiegowi-fp-uniq.txt', 'a+')
    data = []
    f.each { |l| data << l }
    data.uniq.each { |d| fu << d }
    fu.close
  end

  task :cik => :environment do
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Bia%C5%82ystok---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Bielsko-Bia%C5%82a---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Bydgoszcz---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Bytom---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Cz%C4%99stochowa---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Elbl%C4%85g---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Gda%C5%84sk---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Gdynia---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Gliwice---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Gorz%C3%B3w-Wielkopolski---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Katowice---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Kielce---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Krak%C3%B3w---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Lublin---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-%C5%81%C3%B3d%C5%BA---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Olsztyn---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Opole---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Pozna%C5%84---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Radom---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Sopot---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Rybnik---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Sosnowiec---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Szczecin---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Toru%C5%84---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Tychy---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Warszawa---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Wroc%C5%82aw---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Zabrze---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Zielona-G%C3%B3ra---Lista.php'
    # link = 'http://www.cik.org.pl/Certyfikowane-Biura-Rachunkowe-Inne-Miasta---Lista.php'

    f = File.open("lib/assets/ksiegowi.txt", 'a+')
    f << "======= #{link} ========\n"
    page = Nokogiri::HTML(open(link))
    # page = Nokogiri::HTML(open('lib/assets/cik2.html'))
    # divs = page.css('table td#layout_zone1 div div')
    divs = page.css('table td a')
    data = []
    divs.each do |l|
      # lines = d.to_html.split(">")
      # puts l
      if l['title'].present? && l['title'].include?('@')
        data << l['title']
      end
      # lines.each do |l|
      #   if l.include?('mailto')
      #     x = Nokogiri::HTML(l)
      #     mails = x.css('a')
      #     mails.each do |m|
      #       data << m['title']
      #     end
      #   end
      # end
    end

    data.each do |mail|
      f << "#{mail}\n"
      puts mail
    end
    f.close
  end

  def unasci(str)
    str.gsub(/&#/, '').split(';').map { |e| e.to_i.chr }.join
  end

end