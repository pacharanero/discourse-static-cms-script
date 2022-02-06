require 'uri'
require 'net/http'
require 'yaml'
require 'json'
require 'pp'


# Load the config file
config = YAML.load_file('config.yml')

# If destination directory doesn't exist, create it
if !Dir.exists?(config['destination-folder'])
  Dir.mkdir(config['destination-folder'])
  puts "Created destination directory: #{config['destination-folder']} \n"
else 
  puts "Destination directory exists: #{config['destination-folder']} \n"
end

# Get the Markdown content from the Discourse
config['pages'].each do |url|
  
  # construct metadata url based on the baseurl and the topic ID
  base_url = url.split('/t/').first
  topic_title = url.split('/t/').last.split('/').first
  topic_id = url.split('/t/').last.split('/').last
  raw_page_url = base_url + "/raw/" + topic_id
  metadata_url = base_url + "/t/" + topic_id + ".json"
  
  # get raw_data and metadata from Discourse
  raw_page = Net::HTTP.get_response(URI(raw_page_url))
  metadata = Net::HTTP.get_response(URI(metadata_url))
  
  if raw_page.is_a?(Net::HTTPSuccess)
    puts "Downloading raw page #{raw_page_url}"
  else
    puts "Error fetching raw page #{raw_page_url}: #{raw_page.code} #{raw_page.message}. Skipping..."
    next
  end
    
  if metadata.is_a?(Net::HTTPSuccess)
    puts "Downloading metadata #{metadata_url}"
  else
    puts "Error fetching metadata #{metadata_url}: #{metadata.code} #{metadata.message}. Skipping..."
    next
  end
  
  metadata_json = JSON.parse(metadata.body)
  
  # Compose Jekyll front matter
  jekyll_front_matter = <<-JEKYLL
  title: #{metadata_json['title']}
  date: #{metadata_json['created_at']}
  tags: #{metadata_json['tags'].join(' ')}
  ---\n
  JEKYLL
  
  page_content = jekyll_front_matter + raw_page.body
  # puts page_content
  
  # Write the content to the destination directory   
  File.open("#{config['destination-folder']}/#{topic_title}.md", "w") do
    |f| f.write page_content 
  end
end
  