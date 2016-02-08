# encoding: UTF-8
# This file is released into the public domain by Aaron Shafovaloff

require 'json'
require 'unicode'

lastLine = []
data = {}
definition = ""

def stripPunctuation(str)
  str = Unicode::normalize_C str
  str = Unicode::downcase str

  chars = []

  str.each_char do |c|
    c = Unicode::decompose_safe(c)
    chars.push(c[0])
  end

  return chars.join()
end

File.open("dictionary.txt").each_with_index do |line, index|
    next if index < 100
    if line[0..1] == "GK"
        # line = line.gsub(/\p{Z}/, ' ').gsub(/\s+/, ' ')
        # lastLine = line.split(' ')
        lastLine = line.split("   ")
    elsif line[0..4] == "<def>"
        # strongs = lastLine[1].split('G')[1]
        # gk = lastLine[4].split('G')[1]
        # lemma = Unicode::normalize_C(lastLine[5])
        lemma = Unicode::normalize_C lastLine[1]

        # line = line.gsub(/\p{Z}/, ' ').gsub(/\s+/, ' ')
        # tmp1 = line.split('</def>')
        # definition = tmp1[0].split('<def>')[1].strip
        puts line[/<def>(.*)<\/def>/, 1]
        definition = line[/<def>(.*)<\/def>/, 1]

        lemmaWithoutPunctuation = stripPunctuation(lemma)

        data[lemma] = {
            # "lemma" => lemma,
            #   "strongs" => strongs.to_i,
            #   "gk" => gk.to_i,
            "definition" => definition
        }
    end
end

File.open("dictionary2.json","w") do |fileToWrite|
  fileToWrite.write(JSON.pretty_generate(data))
end
