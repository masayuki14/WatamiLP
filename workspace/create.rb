# -*- encoding: utf-8 -*-
require 'yaml'
require 'csv'

ROOT_DIR  = File.dirname(File.expand_path(__FILE__))
config = YAML.load_file(ROOT_DIR + '/config.yml')
source_data = File.join(ROOT_DIR, config['source_data'])

require File.join(ROOT_DIR, 'lib/watami.rb')


### データCSVを読み込んで1行ずつ Watami::Row のインスタンスにする

line = 0
rows = []

CSV.foreach(source_data) do |row|
  line += 1

  # 1行目は属性名の定義
  if line == 1
    Watami::Row.set_attributes(row)
    next
  end

  # 2行目は属性の説明
  # 今のところ使う予定はない
  if line == 2
    Watami::Row.set_descriptions(row)
    next
  end

  # インスタンスにする！
  rows << Watami::Row.new(row)
end

require 'erb'

# 出力先のディレクトリを作成
output_dir = File.join(ROOT_DIR, config['output_dir'])
Dir.mkdir(output_dir) unless Dir.exists?(output_dir)

# erb にデータをバインドして出力
erb_text = nil
File.open(File.join(ROOT_DIR, config['source_index_file']), 'r') { |file| erb_text = file.read }
File.open(File.join(output_dir, config['output_file_name']), 'w') do |file|
  row = rows[0]
  erb = ERB.new(erb_text)
  file.write(erb.result(binding))
end

