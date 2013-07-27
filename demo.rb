#encoding: utf-8

module CaseParser
  class Parser
    attr_accessor :rules
    def initialize rule_kls, file_name
      @rules = rule_kls.rules
      @file = file_name
      @rule = rule_kls
    end

    def before
      @rule.before
    end

    def after
      @rule.after
    end

    def do
      before
      File.open(@file, 'r') do |f|
        f.each_line do |line|
          @rules.each do |rule_name, reg|
            if m = line.match(reg)
              @rule.method("#{rule_name.to_s}_action".to_sym).call(m)
              break;
            end #if
          end
        end #each_line
      end #open 
      after
    end #do

  end #Parser

  class Rule
    def rules
      rs = {}
      methods.grep(/rule$/).each { |r| rs[r] = send(r) }
      rs
    end
    
    def get_rule
      /^打开(.+)/
    end

    def get_rule_action(m)
      puts "@b.get('#{m[1]}')"
    end

    def click_rule
      /^点击(.+\(.+\)$)/
    end

    def click_rule_action(m)
      puts "#{replace_with_find_element m[1]}.click"
    end

    def send_keys_rule
      /^在(.+\(.+\))中输入(.+)/
    end

    def send_keys_rule_action(m)
      puts "#{replace_with_find_element m[1]}.send_keys('#{m[2]}')"
    end

    def replace_with_find_element(token)
      s = ''
      token.scan(/\(.+\)/) {|locator| s = "@b.find_element#{locator}"}
      s
    end

    def before
      puts "require 'selenium-webdriver'"
      puts '@b = Selenium::WebDriver.for :chrome'
    end

    def after
      puts '@b.quit'
    end
  end #Rule

end #CaseParser

rule_kls = CaseParser::Rule.new
CaseParser::Parser.new(rule_kls, ARGV.first).do
