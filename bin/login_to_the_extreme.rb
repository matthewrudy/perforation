# !/usr/bin/ruby
#
# USAGE: ruby bin/login_to_the_extreme.rb *numberofprocesses* *numberofrepeats* *instancenumber* *numberperthread*
#
# eg. running on two slices
#   ruby bin/login_to_the_extreme.rb 400 100 10 1 # runs in 400 process with a round robin of 10 agents (agents 1..4000) logging in 100 times each
#   ruby bin/login_to_the_extreme.rb 400 100  1 2 # runs in 400 process with 1 agent each, as the second instance (agents 401..800) logging in 100 times each
#
require File.dirname(__FILE__)+"/../init"
require 'user'

class ToTheMax
  
  def initialize(i)
    @user = User.nth(i) # username: "user_#{i}", password: "password"
  end
  attr_accessor :user
  
  def start
  end
  
  def perform
    user.login
    user.do_something_minimal
    user.logout
  end
  
  def stop
  end
end

Perforation::Runner.run(ToTheMax)
