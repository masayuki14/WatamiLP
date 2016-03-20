# -*- encoding: utf-8 -*-
require 'yaml'
require 'csv'
require 'fileutils'

ROOT_DIR  = File.dirname(File.expand_path(__FILE__))
config = YAML.load_file(ROOT_DIR + '/config.yml')
source_data = File.join(ROOT_DIR, config['source_data'])

require File.join(ROOT_DIR, 'lib/watami.rb')

### データCSVを読み込んで1行ずつ Watami::Row のインスタンスにする
rows = Watami::Row.parse(source_data)

# 出力先のディレクトリを作成
output_dir = File.join(ROOT_DIR, config['output_dir'])
Dir.mkdir(output_dir) unless Dir.exists?(output_dir)

# img, css, js ディレクトリをコピー
FileUtils.cp_r(File.join(ROOT_DIR, config['source_image_dir']), output_dir)
FileUtils.cp_r(File.join(ROOT_DIR, config['source_css_dir']), output_dir)
FileUtils.cp_r(File.join(ROOT_DIR, config['source_javascript_dir']), output_dir)

# erb にデータをバインドして出力
rows.each { |row| row.write_template(ROOT_DIR, config) }

