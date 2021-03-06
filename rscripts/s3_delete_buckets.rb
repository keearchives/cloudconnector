#!/usr/bin/env ruby

# s3-delete-bucket.rb
# Fog-based script for deleting large Amazon AWS S3 buckets (~100 files/second)
# Forked from this excellent script: https://github.com/SFEley/s3nuke

require 'rubygems'
require 'thread'
require 'fog'

# Ensure a bucket is specified
if ARGV.count == 0
  fail 'specify a bucket'
  return
end

# Set up threads and variables.
bucket_name = ARGV[0]
thread_count = 20
threads = []
queue = Queue.new
semaphore = Mutex.new
total_listed = 0
total_deleted = 0

puts "==Deleting all the files in '#{bucket_name}'=="

# Create new Fog S3. Make sure the credentials are available from ENV.
s3 = Fog::Storage::AWS.new(aws_access_key_id: "#{ENV['AMAZON_ACCESS_KEY_ID']}", aws_secret_access_key: "#{ENV['AMAZON_SECRET_ACCESS_KEY']}")

# Fetch the files for the bucket.
threads << Thread.new do
  Thread.current[:name] = 'get files'
  puts "...started thread '#{Thread.current[:name]}'...\n"
  # Get all the files from this bucket. Fog handles pagination internally.
  s3.directories.get("#{bucket_name}").files.all.each do |file|
    # Add this file to the queue.
    queue.enq(file)
    total_listed += 1
  end
  # Add a final EOF message to signal the deletion threads to stop.
  thread_count.times { queue.enq(:EOF) }
end

# Delete all the files in the queue until EOF with N threads.
thread_count.times do |count|
  threads << Thread.new(count) do |number|
    Thread.current[:name] = "delete files(#{number})"
    puts "...started thread '#{Thread.current[:name]}'...\n"
    # Dequeue until EOF.
    file = nil
    while file != :EOF
      # Dequeue the latest file and delete it. (Will block until it gets a new file.)
      file = queue.deq
      file.destroy if file != :EOF
      # Increment the global synchronized counter.
      semaphore.synchronize { total_deleted += 1 }
      puts "Deleted #{total_deleted} out of #{total_listed}\n" if (rand(100) == 1)
    end
  end
end

# Wait for the threads to finish.
threads.each do |t|
  begin
    t.join
  rescue RuntimeError => e
    puts "Failure on thread #{t[:name]}: #{e.message}"
  end
end

# Delete the bucket.
s3.directories.get("#{bucket_name}").destroy
