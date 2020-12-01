require "msgpack"

class Game
  ALPHABET = [*("a".."z")]

  def initialize
    @misses = []
    @lives = 5
    possible_words = File.read "5desk.txt"
    possible_words = possible_words.split("\r\n").select {
      |word| word.length > 4 && word.length < 13
    }
    @word = possible_words.sample.downcase.split("")
    @hits = []
    @word.length.times { @hits << "_" }
  end

  def to_msgpack
    MessagePack.dump ({
      :misses => @misses,
      :lives => @lives,
      :word => @word,
      :hits => @hits
    })
  end

  def self.from_msgpack(string)
    data = MessagePack.load string
    self.new(data["misses"], data["lives"], data["word"], data["hits"])
  end

  def play
    while @lives > 0
      puts "So far you have #{@hits}"
      puts "You've already guessed : #{@misses}"

      puts "Do you want to save your game and take a break? Y/N"
      input = ""
      loop do
        input = gets.chomp.upcase
        break if input == "N"
        if input == "Y"

      end

      guess = ""
      loop do
        puts "Enter a guess. Remember to only enter a single letter."
        guess = gets.chomp.downcase
        break if ALPHABET.include?(guess) && !@misses.include?(guess) && !@hits.include?(guess)
      end

      if @word.include?(guess)
        @word.each_with_index do |letter, index|
          @hits[index] = guess if letter == guess
        end
        puts "That's a hit!"
        break if @hits == @word
      else
        @misses << guess
        @lives -= 1
        puts "Unlucky!"
      end
    end

    puts "You tried" if @lives == 0
    puts "You guessed it! The word is #{@word.join("")}" if @hits == @word
  end

end
