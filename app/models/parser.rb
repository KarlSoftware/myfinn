#encoding: utf-8
#
require 'mechanize'
require 'date'
require_relative 'apartment.rb'

class Parser

  def parse
    agent = Mechanize.new
    #page = agent.get("http://www.finn.no/finn/realestate/lettings/object?finnkode=38922034")
    page = agent.get("http://www.finn.no/finn/realestate/lettings/object?finnkode=38796462")
    apartment = Apartment.new
    price_infos = parse_objectinfo(page, "Prisinformasjon")
    apartment.rent = get_value_of(price_infos, "Leie pr måned").split(",").first.gsub(/[^0-9]/, "").to_i
    apartment.deposit = get_value_of(price_infos, "Depositum").split(",").first.gsub(/[^0-9]/, "").to_i
    house_info = parse_objectinfo(page, "Fakta om boligen")
    apartment.size = get_value_of(house_info, "Primærrom")
    apartment.floor = get_value_of(house_info, "Etasje").gsub(/[^0-9]/, "").to_i
    dates = get_value_of(house_info, "Leieperiode")
    if dates != ""
      if dates =~ /\-/
        apartment.start_date = DateTime.parse(dates.split("-")[0].strip)
        apartment.end_date   = DateTime.parse(dates.split("-")[1].strip)
      else
        apartment.start_date = DateTime.parse(dates.strip)
      end
    end
    apartment.features = parse_features(page).map do |text|
      feature = Feature.new
      feature.description = text
      feature
    end
    apartment.contacts = parse_contacts(page).map do |values|
      contact = ContactInfo.new
      contact.type = values.keys.first
      contact.value = values.values.first
      contact
    end
    apartment.html_description = get_description_html(page)
    return apartment
  end

  private 
  def get_value_of(values, target)
    value = values.select { |x| x[target] }.first
    return value ? value[target] : ""
  end

  def parse_contacts(page)
    result = []
    target = page.search('#brokerContact-0').first
      if target 
        target.search('dl.multicol').each do |element|
          labels = element.search('dt')
          values = element.search('dd')
          labels.zip(values).each do |pair|
            result << { pair[0].inner_text => pair[1].content.strip.split("\r\n").first.strip }
          end
        end
      end
    return result
  end

  def parse_objectinfo(page, header)
    result = []
    page.search('div.bd.objectinfo').each do |test|
      if test.search('h2').first && test.search('h2').first.inner_text == header
        test.search('dl.multicol.colspan2').each do |element|
          labels = element.search('dt')
          values = element.search('dd')
          labels.zip(values).each do |pair|
            result << { pair[0].inner_text => pair[1].content.strip.split("\r\n").first.strip }
          end
        end
      end
    end
    return result
  end

  def parse_features(page)
    result = []
    page.search('div.mod').each do |element|
      if element.search('h2').first && element.search('h2').first.inner_text == "Fasiliteter"
        result = element.search('p.mvn').map { |x| x.inner_text.strip.downcase.capitalize }
      end
    end
    return result
  end

  def get_description_html(page)
    element = page.search('#description .bd').first
    return "" unless element
    return element.inner_html.encode("utf-8").strip.gsub("\n", "<br/>")
  end
end