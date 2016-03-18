# -*- encoding: utf-8 -*-
require 'yaml'
require 'csv'

ROOT_DIR  = File.dirname(File.expand_path(__FILE__))
config = YAML.load_file(ROOT_DIR + '/config.yml')
source_data = File.join(ROOT_DIR, config['source_data'])

p config
p source_data

line = 0
CSV.foreach(source_data) do |row|
  line += 1
  next if line > 3
  p row
end
