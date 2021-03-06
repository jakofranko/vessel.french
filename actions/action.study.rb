#!/bin/env ruby
# encoding: utf-8

class ActionStudy

    include Action

    def initialize q = nil

        super

        @name = "Study"
        @docs = "Basic French words and phrases. Use in the console via \"bind french study\""

    end

    # TODO: allow flexibility of which word list to study by passing in the name of the memory
    def act q = nil
        if !@vocabulary then @vocabulary = Memory_Array.new("vocabulary", @host.path).to_a end

        if !$nataniev.console_memory[@host.name] then
            $nataniev.console_memory[@host.name] = {"active" => nil, "history" => [], "correct" => []}
        end

        active_word = $nataniev.console_memory[@host.name]['active']

        if q.to_s != "" && active_word
            if active_word.english.like(q)
                active_word.score = 1
                $nataniev.console_memory[@host.name]['correct'].push(active_word.french)
                puts "Correct!"
                puts score
            else
                active_word.score = -1
                puts "Sorry! The english translation of #{active_word.french} is \"#{active_word.english}\"."
                puts score
            end
        elsif active_word
            active_word.score = 0
            puts "The English translation of #{active_word.french.capitalize} is \"#{active_word.english}\"."
        end

        if $nataniev.console_memory[@host.name]['correct'].length == @vocabulary.length
            puts "You have correctly translated all of the vocabulary words! Starting over..."
            $nataniev.console_memory[@host.name]['correct'] = []
        end

        word = ''
        loop do
            word = @vocabulary.sample
            break unless $nataniev.console_memory[@host.name]['correct'].include? word['FRENCH']
        end
        active_word = Word.new(word['ENGLISH'], word['FRENCH'])
        $nataniev.console_memory[@host.name]['active'] = active_word
        $nataniev.console_memory[@host.name]['history'].push(active_word)

        return "##{history.length}: What is #{active_word.french} in english?"

    end

    def score

        known = {}
        points = 0
        history.each do |word|
            known[word.french] = word.english
            points += word.score
        end

        progress = ((known.length/@vocabulary.length.to_f) * 1000).to_i
        success  = ((points/known.length.to_f) * 1000).to_i

        return "Your score is #{points}pts, Success #{success.to_f/10}%, Progress #{progress.to_f/10}%"

    end

    def history

        return $nataniev.console_memory[@host.name]['history']

    end

end

class Word

    attr_accessor :english
    attr_accessor :french
    attr_accessor :score

    def initialize english, french

        @english = english
        @french = french
        @score   = 0

    end

end
