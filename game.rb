require "yaml"
require "byebug"

class Game
  ALPHABET = [*("a".."z")]

  def initialize(misses = [], lives = 5, word = "", hits = [])
    @misses = misses
    @lives = lives
    @word = word
    if @word.length == 0
      possible_words = File.read "5desk.txt"
      possible_words = possible_words.split("\r\n").select {
      |word| word.length > 4 && word.length < 13
      }
      @word = possible_words.sample.downcase.split("")
    end
    @hits = hits
    @word.length.times { @hits << "_" } if @hits.length == 0
  end

  def to_yaml
    YAML.dump ({
      :misses => @misses,
      :lives => @lives,
      :word => @word,
      :hits => @hits
    })
  end

  def self.from_yaml(string)
    data = YAML.load string
    self.new(data[:misses], data[:lives], data[:word], data[:hits])
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
          Dir.mkdir("saves") unless Dir.exist? "saves"
          save = to_yaml
          filename = "saves/#{@hits.join("")}.txt"
          File.open(filename, "w"){ |somefile| somefile.puts save}
          return
        end
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
