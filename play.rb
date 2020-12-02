require "./game.rb"

game = ""


puts "Do you want to start a new game or load a saved one? Input new or load"
loop do
  input = gets.chomp.downcase
  if input == "new"
    game = Game.new
    puts "New game started"
    break
  elsif input == "load"
    saves = Dir.entries("saves")
    saves = saves.delete_if { |filename| filename == ".." || filename == "." }
    puts "The following saved games exist :"
    saves.each_with_index { |save, index| puts "Index: #{index} Name: #{save}"  }
    puts "Select a save by entering the corresponding index number. If you enter a non-number value you will be given the first save in the column."

    loop do
      choice = gets.chomp.to_i
      if choice >= 0 && choice < saves.length
        save_file = saves[choice]
        puts "You've selected #{save_file}"
        save_data = File.read("saves/#{save_file}")
        game = Game.from_yaml(save_data)
        File.delete("saves/#{save_file}")
        break
      end
    end
    break
  end
end

game.play
