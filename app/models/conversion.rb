module Csv2Xml
  require 'csv'

# This isn't going to change so just make it a constant (CAPITALIZED variables are constant)
  XML_HEADER = "<?xml version='1.0' encoding='UTF-8'?>\n<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9' xmlns:xhtml='http://www.w3.org/1999/xhtml'>"

# I modified your code to accept data as a block, rather than using :loc_tag_open, :loc_tag_close
  def loc_tag(output_file, url)
    write output_file, "<url>"
    write output_file, "\t<loc>#{url}</loc>"
    yield
    write output_file, "</url>"
  end

# I renamed these functions to better reflect their purpose
  def link_tag(output_file, map = {})
    write output_file, "\t<xhtml:link rel='alternate' hreflang='#{map[:lang]}' href='#{map[:url].strip}'/>"
  end

  def write(file, data)
    file.puts(data)
    self.formatted_xml_data << "#{data}\n"
  end


# Find each file with a .csv extension in this folder

  def open_csv(filename)

    filename = "#{Rails.root}/public#{filename.to_s}"

    File.open(filename, "r") do |csv_file|
      File.open("#{csv_file.path}.xml".gsub(/\.csv/i, ''), "w+") do |xml_file|
        xml_file.puts XML_HEADER

        rows = CSV.read csv_file # CSV reads spreadsheet into nested arrays. Column cells are nested within row arrays.
        language_names = rows.shift # Column names are in the first row

        # The compact method automatically ignores non-nil members of the array so you dont need to call next
        rows.compact.each do |columns| # Rows shouldn't be nil anyways.
          columns.compact.each do |url|
            # Print the <loc> tag for this URL and it's corresponding nested language mappings
            loc_tag(xml_file, url) do

              # If you want to keep things simple keep in mind that both of the following will work:
              #   1.) columns.each_with_index { |column, index| link_tag xml_file, column, language_names[index] }
              #   2.) language_names.each_with_index { |lang, lang_idx| link_tag xml_file, columns[lang_idx], lang }
              #
              # This is because there's a 1:1 mapping from language_names to columns for a single row. Therefore, A better,
              # cleaner way of doing things would be to use a Hash instead of two arrays. This also allows us to use two
              # parameters to link_tag instead of three.
              #
              # Since the receiving function requires one less argument, I prefer this approach.
              #   although 1.) and 2.) may be simpler to understand
              Hash[language_names.zip columns].each do |lang, url|
                link_tag xml_file, lang: lang, url: url
              end
            end
          end
        end

        xml_file.puts "</urlset>"

        return xml_file
      end
    end

  end

end


class Conversion < ActiveRecord::Base
  attr_accessible :author, :csv_file, :formatted_xml_data, :formatted_xml_filename, :description
  mount_uploader :csv_file, CsvFileUploader

  include Csv2Xml

  after_save :process_csv_file

  validates_presence_of :csv_file

  def clean_xml_filename
    self.formatted_xml_filename[/\/\w+\.\w+$/i].gsub('/', '') if self.formatted_xml_filename[/\/\w+\.\w+$/i]
  end

  def filename
    clean_xml_filename[/\w+/]
  end

 def to_param
   "#{self.id}-#{self.filename.gsub('.', '_')}"
 end

  private

  def process_csv_file
    xml_file = open_csv(self.csv_file)
    self.update_column(:formatted_xml_filename, "#{csv_file}.xml".gsub(/\.csv/i, ''))
    self.update_column(:formatted_xml_data, self.formatted_xml_data)
  end


end

