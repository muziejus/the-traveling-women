require 'json'

places = JSON.parse(File.read("ruby.json"))
File.open("places.csv", "w") do |csv|
  csv.write  "name,toponym,latitude,longitude,datetime\n"
  places.each do |place|
    csv.write "#{place["properties"]["name"]},#{place["properties"]["toponym"]},#{place["geometry"]["coordinates"][1]},#{place["geometry"]["coordinates"][0]},#{place["properties"]["datetime"]}\n"
  end
end
