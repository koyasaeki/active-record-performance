#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'active_record'
require 'memory_profiler'
require 'benchmark/ips'

RECORD_COUNT = 1000
SEPARATOR = "=" * 70

def bytes_to_kb(bytes)
  (bytes / 1024.0).round(2)
end

def format_memory(bytes)
  "#{bytes_to_kb(bytes)} KB"
end

def setup_database
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  ActiveRecord::Schema.define do
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :age
      t.string :address
      t.string :phone
      t.string :company
      t.string :department
      t.date :birth_date
      t.timestamps
    end
  end
end

class User < ActiveRecord::Base
end



def create_test_data
  RECORD_COUNT.times do |i|
    User.create!(
      name: "User #{i}",
      email: "user#{i}@example.com",
      age: 20 + (i % 50),
      address: "Address #{i}, Tokyo",
      phone: "090-1234-#{i.to_s.rjust(4, '0')}",
      company: "Company #{i % 100}",
      department: "Department #{i % 10}",
      birth_date: Date.new(1980 + (i % 30), (i % 12) + 1, (i % 28) + 1)
    )
  end
end

def run_benchmark(label, &block)
  result = nil
  report = MemoryProfiler.report { result = block.call }

  {
    label: label,
    allocated: report.total_allocated_memsize,
    retained: report.total_retained_memsize,
    objects: report.total_allocated,
    data: result
  }
end

def print_result(result)
  puts "\n[#{result[:label]}]"
  puts "  Allocated: #{format_memory(result[:allocated])}"
  puts "  Retained:  #{format_memory(result[:retained])}"
  puts "  Objects:   #{result[:objects]}"
end

def print_comparison(ar_result, plain_result)
  ar_kb = bytes_to_kb(ar_result[:retained])
  plain_kb = bytes_to_kb(plain_result[:retained])
  ratio = ar_result[:retained].to_f / plain_result[:retained]
  diff_percent = ((ratio - 1) * 100).round(1)

  puts "\n#{SEPARATOR}"
  puts "Summary"
  puts SEPARATOR
  puts "ActiveRecord retained: #{ar_kb} KB"
  puts "Hash retained:         #{plain_kb} KB"
  puts "Ratio (AR / Plain):    #{ratio.round(2)}x"
  puts "Difference:            +#{diff_percent}% more memory with ActiveRecord"
end

def main
  puts "ActiveRecord vs Plain Ruby - Memory Benchmark"
  puts SEPARATOR

  puts "\nSetting up database..."
  setup_database

  puts "Creating #{RECORD_COUNT} records..."
  create_test_data

  ar_result = run_benchmark("ActiveRecord") { User.all.to_a }
  print_result(ar_result)

  plain_result = run_benchmark("Hash") do
    User.pluck(:id, :name).map do |id, name|
      {
        id: id,
        name: name
      }
    end
  end
  print_result(plain_result)

  print_comparison(ar_result, plain_result)

  puts "\n#{SEPARATOR}"
  puts "Performance Benchmark (iterations per second)"
  puts SEPARATOR

  Benchmark.ips do |x|
    x.config(time: 3, warmup: 1)

    x.report("ActiveRecord") { User.all.to_a }
    x.report("Hash (pluck)") do
      User.pluck(:id, :name).map { |id, name| { id: id, name: name } }
    end

    x.compare!
  end
end

main if __FILE__ == $0
