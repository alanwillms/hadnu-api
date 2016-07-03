# rails import:categories:banners FILES_PATH=yyy
# rails paperclip:refresh:missing_styles
namespace :import do
  def upload_path
    upload_path = ENV.fetch('FILES_PATH', '').chomp('/')
    if upload_path.empty?
      puts 'ERROR: Missing directory path via FILES_PATH=/path/to/dir'
      exit
    end
    upload_path
  end

  namespace :authors do
    task photos: :environment do
      desc 'Import Hadnu 4 authors photos to Hadnu 5'

      Author.all.each do |author|
        next if author.photo_file.nil? || author.photo_file.empty?
        file_path = "#{upload_path}/authorsPhotos/#{author.photo_file}"
        next unless File.exist?(file_path)
        puts "Importing: #{file_path}"
        author.photo = open(file_path)
        puts author.errors.inspect unless author.save
      end
    end
  end

  namespace :categories do
    task banners: :environment do
      desc 'Import Hadnu 4 categories banners to Hadnu 5'

      Category.all.each do |category|
        next if category.banner_file.nil? || category.banner_file.empty?
        file_path = "#{upload_path}/categoriesBanners/#{category.banner_file}"
        next unless File.exist?(file_path)
        puts "Importing: #{file_path}"
        category.banner = open(file_path)
        puts category.errors.messages.inspect unless category.save
      end
    end
  end

  namespace :publications do
    task banners: :environment do
      desc 'Import Hadnu 4 publications banners to Hadnu 5'

      Publication.all.each do |publicaton|
        next if publicaton.banner_file.nil? || publicaton.banner_file.empty?
        file_path = "#{upload_path}/publicationsBanners/#{publicaton.banner_file}"
        next unless File.exist?(file_path)
        puts "Importing: #{file_path}"
        publicaton.banner = open(file_path)
        puts publicaton.errors.messages.inspect unless publicaton.save
      end
    end

    task pdfs: :environment do
      desc 'Import Hadnu 4 publications PDFs to Hadnu 5'

      Publication.all.each do |publication|
        next if publication.pdf_file.nil? || publication.pdf_file.empty?
        file_path = "#{upload_path}/publicationsPdfsDir/#{publication.pdf_file}"
        next unless File.exist?(file_path)
        puts "Importing: #{file_path}"
        publication.pdf = open(file_path)
        puts publication.errors.inspect unless publication.save
      end
    end
  end
end
