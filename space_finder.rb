require 'httparty'

places = JSON.parse(File.read("ruby.json"))
unique_coordinates = places.map{ |p| { lat: p["geometry"]["coordinates"][1].round(3), lng: p["geometry"]["coordinates"][0].round(3) } }.uniq
File.open("coords.csv", "w") do |csv|
  csv.write "lat, lng, name\n"
  unique_coordinates.each do |coord|
    puts "sending lat=#{coord[:lat]}&lng=#{coord[:lng]}"
    q = "http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{coord[:lat]}&lng=#{coord[:lng]}&username=moacir"
    results = JSON.parse(HTTParty.get(q).body)["geonames"]
    puts "The results are:"
    puts results
    if results.nil?
      name = nil
    else
      name = results[0]["name"]
    end
    coord[:name] = name
    csv.write "#{coord[:lat]}, #{coord[:lng]}, #{name}\n"
    sleep(10)
  end
end
places.each do |place|
  lat = place["geometry"]["coordinates"][1].round(3)
  lng = place["geometry"]["coordinates"][0].round(3)
  lats = unique_coordinates.select{ |c| c[:lat] == lat }
  lngs = lats.select{ |l| l[:lng] == lng }
  if lngs.length == 1
    place["properties"]["toponym"] = lngs[0][:name]
  else
    puts "broke on #{place}"
  end
end
File.open("new_ruby.json","w") do |f|
    f.write(places.to_json)
end

