#
# Get a list of our images ################################################################### 

my_images_raw = connection.describe_images(‘Owner’ => ‘self’)
my_images = my_images_raw.body[“imagesSet”]

puts “\n###################################################################################” 
puts “Following images are available for deployment” puts “\nImage ID\tArch\t\tImage Location”

for key in 0…my_images.length 
	print my_images[key][“imageId”], “\t” , my_images[key][“architecture”] , “\t\t” , my_images[key][“imageLocation”],  “\n”; 
end

#
# Get a list of all instance flavors ################################################################### 
flavors = connection.flavors()
print “\n\n============\nFlavors\n============\n” 
flavors.table([:bits, :cores, :disk, :ram, :name]) 
flavors.table


