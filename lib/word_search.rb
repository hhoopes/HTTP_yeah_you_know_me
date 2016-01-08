

class WordSearch
  attr_reader :dictionary, :word

  def initialize
    @dictionary = File.read('/usr/share/dict/words')
  end

  def find_word(path)
    word = path.split("?")[1].split("=")[1]
    if dictionary.include?(word.downcase)
      "#{word} is a known word!"
    else
      "#{word} is NOT a known word!"
    end
  end

end
