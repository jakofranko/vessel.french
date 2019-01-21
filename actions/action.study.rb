#!/bin/env ruby
# encoding: utf-8

class ActionStudy

  include Action

  def initialize q = nil

    super

    @name = "Study"
    @docs = "Basic French words and phrases."

  end

  def act q = nil

    if !$nataniev.console_memory[@host.name] then $nataniev.console_memory[@host.name] = {"active" => nil,"history" => []} end

    @vocabulary = Memory_Array.new("vocabulary",@host.path).to_a.shuffle

    active_word = $nataniev.console_memory[@host.name]['active']

    if q.to_s != "" && active_word
      if active_word.english.like(q)
        active_word.score = 1
        puts "Correct!"
        puts score
      else
        active_word.score = -1
        puts "Sorry! The english translation of #{active_word.russian} is \"#{active_word.english}\"."
        puts score
      end
    elsif active_word
      active_word.score = 0
      puts "The English translation of #{active_word.russian.capitalize} is \"#{active_word.english}\"."
    end

    word = @vocabulary.sample
    active_word = Word.new(word['ENGLISH'],word['RUSSIAN'])
    $nataniev.console_memory[@host.name]['active'] = active_word
    $nataniev.console_memory[@host.name]['history'].push(active_word)

    return "##{history.length}: What is #{active_word.russian} in english?"

  end

  def score

    known = {}
    points = 0
    history.each do |word|
      known[word.russian] = word.english
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
  attr_accessor :russian
  attr_accessor :score

  def initialize english, russian

    @english = english
    @russian = russian
    @score   = 0

  end

end
