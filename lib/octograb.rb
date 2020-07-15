# frozen_string_literal: true

require 'octograb/version'
require 'typhoeus'
require 'resolv'
require 'colorize'
require 'ruby-progressbar'

module Octograb
  class Octograbber
    def initialize(params)
      @threads = params[:threads] || 50
      user_agent = params[:useragent] || 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36'
      @path = params[:path] || '/'
      @content = params[:content]
      @inputfile = params[:inputfile]
      @follow_r = params[:follow_r] || false

      Typhoeus::Config.user_agent = user_agent
    end

    def run
      File.readlines(@inputfile).each do |line|
        # do not overload the queue
        hydra.run if hydra.queued_requests.size > 50

        r1 = Typhoeus::Request.new("http://#{line.strip}#{@path}",
                                   followlocation: @follow_r,
                                   timeout: 1)
        r1.on_complete do |response|
          progressbar.increment
          progressbar.log "[+] Content match: #{r1.url}".green if response.body.include? @content
        end
        r2 = Typhoeus::Request.new("https://#{line.strip}#{@path}",
                                   followlocation: @follow_r,
                                   ssl_verifyhost: 0,
                                   timeout: 1)
        r2.on_complete do |response|
          progressbar.increment
          progressbar.log "[+] Content match: #{r2.url}".green if response.body.include? @content
        end
        hydra.queue(r1)
        hydra.queue(r2)

        # check if current line is already an ip address
        if line.strip =~ Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex) ? true : false
          progressbar.total -= 2
        else
          begin
            ip = dns.getaddress(line.strip)
            r3 = Typhoeus::Request.new("http://#{ip}#{@path}",
                                       followlocation: @follow_r,
                                       timeout: 1)
            r3.on_complete do |response|
              progressbar.increment
              progressbar.log "[+] Content match: #{r3.url}".green if response.body.include? @content
            end
            r4 = Typhoeus::Request.new("https://#{ip}#{@path}",
                                       followlocation: @follow_r,
                                       timeout: 1,
                                       ssl_verifyhost: 0)
            r4.on_complete do |response|
              progressbar.increment
              progressbar.log "[+] Content match: #{r4.url}".green if response.body.include? @content
            end
            hydra.queue(r3)
            hydra.queue(r4)
          rescue StandardError
            progressbar.total -= 2
          end
        end
      end

      # run the last "< 50" requests
      hydra.run
    end

    protected

    def hydra
      @hydra ||= Typhoeus::Hydra.new(max_concurrency: @threads)
    end

    def progressbar
      @progressbar ||= ProgressBar.create(title: 'Progress',
                                          starting_at: 0,
                                          total: IO.readlines(@inputfile).size * 4,
                                          format: "%a %b\u{15E7}%i %p%% %t",
                                          progress_mark: ' ',
                                          remainder_mark: "\u{FF65}")
    end

    def dns
      @dns ||= Resolv::DNS.open
    end
  end
end
