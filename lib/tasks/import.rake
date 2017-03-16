require 'open-uri'

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

  namespace :sections do
    task fix_tags: :environment do
      desc "Fixing <img> and \\\" in section.text"
      include Rails.application.routes.url_helpers

      Section.all.each do |section|
        next if section.text.nil?
        puts section.title

        base_url = publication_section_url(section.publication, section) + '/images/'
        replacements = {
          %r{\"} => '"',
          %r{(static/){0}images/symbols/} => 'static/images/symbols/',
          %r{(static/){0}images/layout/} => 'static/images/layout/',
          %r{<livrourl>/} => base_url,
          %r{<livrourl>} => base_url,
          /\/library\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\// => base_url,
          /http\:\/\/hadnu\.org\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\// => base_url,
          /\/sections\-images\/view\?section\_id\=\d+\&amp\;file\=\// => base_url,
          %r{http\://hadnu.org/sections-images/view\?section\_id\=\d+\&amp\;file\=} => base_url
        }

        text = section.text
        replacements.each { |from, to| text = text.gsub(from, to) }
        section.update_attribute :text, text
      end
    end

    task images: :environment do
      desc 'Import Hadnu 4 uploaded images to Paperclip'
      include Rails.application.routes.url_helpers

      search = "#{upload_path}/publicationsUploadedImages/*/*/*"

      Dir[search].each do |image_path|
        data = image_path.gsub("#{upload_path}/publicationsUploadedImages/", '').split('/')
        publication_id, section_id, file_name = data
        puts image_path

        image = Image.find_by({
          publication_id: publication_id.to_i,
          section_id: section_id.to_i,
          file_file_name: file_name
        })

        unless image
          image = Image.new
          image.publication_id = publication_id.to_i
          image.section_id = section_id.to_i
          image.file = open(image_path)
          image.save
        end

        section = Section.find_by_id(section_id.to_i)

        base_url = publication_section_url(section.publication, section) + '/images/'
        old_image_url = "#{base_url}#{image.file_file_name}"
        new_image_url = "#{base_url}#{image.id}"

        puts "\t#{old_image_url}\n\t#{new_image_url}\n"

        query = Section.where('text like ?', "%#{old_image_url}%")

        query.each do |section|
          puts "\tReplacing \"#{section.title}\"..."
          text = section.text.gsub(old_image_url, new_image_url)
          section.update_attribute :text, text
        end

        puts "\n"
      end
    end
  end

  # namespace :authors do
  #   task photos: :environment do
  #     desc 'Import Hadnu 4 authors photos to Hadnu 5'
  #
  #     Author.all.each do |author|
  #       next if author.photo_file.nil? || author.photo_file.empty?
  #       file_path = "#{upload_path}/authorsPhotos/#{author.photo_file}"
  #       next unless File.exist?(file_path)
  #       puts "Importing: #{file_path}"
  #       author.photo = open(file_path)
  #       puts author.errors.inspect unless author.save
  #     end
  #   end
  # end
  #
  # namespace :users do
  #   task photos: :environment do
  #     desc 'Import user photos from Gravatar or create a beautiful image from Unsplash'
  #
  #     User.order(:id).each do |user|
  #       url = [
  #         'https://www.gravatar.com/avatar/',
  #         Digest::MD5.hexdigest(user.email),
  #         '?s=200&d=404'
  #       ].join
  #_images     begin
  #         user.photo = open(url)
  #         url_loaded = true
  #       rescue OpenURI::HTTPError
  #         begin
  #           url = "https://unsplash.it/200/200/?random"
  #           user.photo = open(url)
  #           url_loaded = true
  #         rescue OpenURI::HTTPError
  #           url = "<NOT FOUND>"
  #         end
  #       end
  #
  #       user.save if url_loaded
  #       puts "#{user.login}:\t\t#{url}"
  #     end
  #   end
  # end
  #
  # namespace :categories do
  #   task banners: :environment do
  #     desc 'Import Hadnu 4 categories banners to Hadnu 5'
  #
  #     Category.all.each do |category|
  #       next if category.banner_file.nil? || category.banner_file.empty?
  #       file_path = "#{upload_path}/categoriesBanners/#{category.banner_file}"
  #       next unless File.exist?(file_path)
  #       puts "Importing: #{file_path}"
  #       category.banner = open(file_path)
  #       puts category.errors.messages.inspect unless category.save
  #     end
  #   end
  # end
  #
  # namespace :publications do
  #   task banners: :environment do
  #     desc 'Import Hadnu 4 publications banners to Hadnu 5'
  #
  #     Publication.all.each do |publicaton|
  #       next if publicaton.banner_file.nil? || publicaton.banner_file.empty?
  #       file_path = "#{upload_path}/publicationsBanners/#{publicaton.banner_file}"
  #       next unless File.exist?(file_path)
  #       puts "Importing: #{file_path}"
  #       publicaton.banner = open(file_path)
  #       puts publicaton.errors.messages.inspect unless publicaton.save
  #     end
  #   end
  #
  #   task pdfs: :environment do
  #     desc 'Import Hadnu 4 publications PDFs to Hadnu 5'
  #
  #     Publication.all.each do |publication|
  #       next if publication.pdf_file.nil? || publication.pdf_file.empty?
  #       file_path = "#{upload_path}/publicationsPdfsDir/#{publication.pdf_file}"
  #       next unless File.exist?(file_path)
  #       puts "Importing: #{file_path}"
  #       publication.pdf = open(file_path)
  #       puts publication.errors.inspect unless publication.save
  #     end
  #   end
  # end
end
