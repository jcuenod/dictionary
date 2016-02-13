# encoding: UTF-8
# This file is released into the public domain by
# - Aaron Shafovaloff
# - James Cuénod


require 'json'
require 'unicode'

lastLine = []
data = {}

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
        lastLine = line.split "   "
    elsif line[0..4] == "<def>"
        referenceNumbers = lastLine[0].split " | "
        gk = referenceNumbers[0].gsub(/^GK\ G/, "").to_i
        strongs = referenceNumbers[1].gsub(/^S\ /, "").gsub(/G/, "").split(/,\ /).map(&:to_i)

        lemma = Unicode::normalize_C lastLine[1]
        transliteration = lastLine[2]
        frequencyCount = lastLine[3].gsub(/x$/, "").to_i

        # Note here that sometimes data is discarded
        # e.g. see ἅγιος, after </def> there is still data:
        # "</def>→ consecrate; holy; sacred; saint; sanctify."
        definition = line[/<def>(.*)<\/def>/, 1]

        lemmaWithoutPunctuation = stripPunctuation(lemma)

        data[lemmaWithoutPunctuation] = {
            "gk" => gk,
            "strongs" => strongs,
            "lemma" => lemma,
            "transliteration" => transliteration,
            "frequencyCount" => frequencyCount,
            "definition" => definition
        }
    end
end

File.open("dictionary.json","w") do |fileToWrite|
  fileToWrite.write(JSON.pretty_generate(data))
end
