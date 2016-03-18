# -*- encoding: utf-8 -*-
require 'yaml'
require 'csv'

ROOT_DIR  = File.dirname(File.expand_path(__FILE__))
config = YAML.load_file(ROOT_DIR + '/config.yml')
source_data = File.join(ROOT_DIR, config['source_data'])

require File.join(ROOT_DIR, 'lib/watami.rb')

#p config
#p source_data

line = 0
rows = []

CSV.foreach(source_data) do |row|
  line += 1

  if line == 1
    Watami::Row.set_attributes(row)
    next
  end

  if line == 2
    Watami::Row.set_descriptions(row)
    next
  end

  rows << Watami::Row.new(row)
end

p rows
