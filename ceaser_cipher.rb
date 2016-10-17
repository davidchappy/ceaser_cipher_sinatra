require 'sinatra'
require 'sinatra/reloader' if development?

class CeaserCipher

  def cipher(string, shift=3)
    unless string.is_a?(String)
      return "Please type a phrase below"
    end
    ciphered_words = []
    excluded = (0..64).to_a.concat (91..96).to_a.concat (123..127).to_a
    string.split(" ").each do |word|
      new_word = []
      word.split("").each do |letter|
        capitalized = false
        value = letter.ord
        if value.between?(65, 90) 
          capitalized = true
          value = value + 32
        end
        unless excluded.include?(value)
          value = value + shift 
          if value > 122
            value = value - 26
          end
          if capitalized == true
            value = value - 32
          end
          letter = value.chr
        end
        new_word << letter
      end
      ciphered_words << new_word.join
    end
    ciphered_string = ciphered_words.join(' ')
  end


end

get '/' do
  cipher = CeaserCipher.new
  unless params.nil?
    phrase = params["phrase"] unless params["phrase"].nil? || params["phrase"] == ""
    offset = 3
    offset = params["offset"] unless params["offset"].nil? || params["offset"] == ""
  end

  ciphered = cipher.cipher(phrase, offset.to_i)

  erb :index, :locals => {:ciphered => ciphered}
end