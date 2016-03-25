# -*- encoding: utf-8 -*-
require 'yaml'
require 'csv'
require 'fileutils'

ROOT_DIR  = File.dirname(File.expand_path(__FILE__))
config = YAML.load_file(ROOT_DIR + '/config.yml')
source_data = File.join(ROOT_DIR, config['source_data'])

require File.join(ROOT_DIR, 'lib/watami.rb')

### データCSVを読み込んで1行ずつ Watami::Row のインスタンスにする
Watami::Row.load_master(File.join(ROOT_DIR, 'master'))
rows = Watami::Row.parse(source_data)

# 出力先のディレクトリを作成
output_dir = File.join(ROOT_DIR, config['output_dir'])
FileUtils.mkdir_p(output_dir)

# erb にデータをバインドして出力
erb_file = File.join(ROOT_DIR, config['source_index_file'])
output_file_dir = ''
rows.each do |row|
  row.bind_erb(erb_file) do |binded|
    # 出力ファイル名とディレクトリの作成
    output_file     = File.join(output_dir, row.replace_by_attr(config['output_file_name']))
    output_file_dir = File.dirname(File.expand_path(output_file))
    FileUtils.mkdir_p(output_file_dir)

    # assetsをコピー
    if config['assets_copy_mode'] == 'separate' ||
        (config['assets_copy_mode'] == 'auto' && output_dir != output_file_dir)

      FileUtils.cp_r(File.join(ROOT_DIR, config['source_image_dir']), output_file_dir)
      FileUtils.cp_r(File.join(ROOT_DIR, config['source_css_dir']), output_file_dir)
      FileUtils.cp_r(File.join(ROOT_DIR, config['source_javascript_dir']), output_file_dir)
    end

    File.open(output_file, 'w') { |file| file.write(binded) }
  end
end

# img, css, js ディレクトリをコピー
if config['assets_copy_mode'] == 'bulk' ||
    (config['assets_copy_mode'] == 'auto' && output_dir == output_file_dir)
  FileUtils.cp_r(File.join(ROOT_DIR, config['source_image_dir']), output_dir)
  FileUtils.cp_r(File.join(ROOT_DIR, config['source_css_dir']), output_dir)
  FileUtils.cp_r(File.join(ROOT_DIR, config['source_javascript_dir']), output_dir)
end
