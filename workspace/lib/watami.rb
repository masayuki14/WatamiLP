# -*- encoding: utf-8 -*-
require 'erb'

module Watami
  class Row

    ### class instance members
    @attr_to_index = {}
    @index_to_attr = {}
    @descriptions  = {}
    @master_data   = {}


    ### class methods
    class << self

      ### CSVファイルをロードしてRowクラスの配列にする
      def parse(source_csv_file)
        Encoding.default_external = 'UTF-8'
        line = 0
        rows = []

        CSV.foreach(source_csv_file) do |row|
          line += 1

          # 1行目は属性名の定義
          if line == 1
            set_attributes(row)
            next
          end

          # 2行目は属性の説明
          # 今のところ使う予定はない
          if line == 2
            set_descriptions(row)
            next
          end

          # インスタンスにする！
          rows << Watami::Row.new(row)
        end

        return rows
      end

      ### マスタデータを読み込んでクラスインスタンス変数に格納
      def load_master(master_dir)
        Dir.glob(File.join(master_dir, '*.yml')) do |filename|
          yaml = YAML.load_file(filename)
          /(.*\/)?(.*)\.yml/.match(filename)
          @master_data[$2] = yaml
        end
      end

      ### 属性の定義
      # attributes = ['name', 'shop'] の場合
      # name, name=, shop, shop= のアクセッサを定義する
      def set_attributes(attributes)
        attributes.each_index do |index|
          attr = attributes[index]
          # メソッドを定義
          if @master_data[attr]
            # 読み込みはマスタを返す
            attr_accessor attr
            alias_method("origin_#{attr}", attr)
            define_method(attr) do
              value = self.send("origin_#{attr}") # 設定値
              self.class.master_data[attr][value]
            end
          else
            # マスタがなければアクセッサを定義
            attr_accessor attr
          end
          @attr_to_index[attr] = index
          @index_to_attr[index] = attr
        end
      end

      def set_descriptions(descriptions)
        descriptions.each_index do |index|
          @descriptions[index] = descriptions[index]
        end
      end

      def attr_to_index
        @attr_to_index
      end

      def index_to_attr
        @index_to_attr
      end

      def descriptions
        @descriptions
      end

      def master_data
        @master_data
      end
    end


    ### instance methods

    def initialize(data)
      data.each_index do |index|
        attr = self.class.index_to_attr[index]
        self.send("#{attr}=", data[index])
      end
    end

    ### [erb_file]を読み込んで[output_file]に出力する
    def write_template(root_dir, config)
      erb_file    = File.join(root_dir, config['source_index_file'])
      output_file = File.join(root_dir, config['output_dir'], "#{shopid}_#{config['output_file_name']}")

      erb_text = nil
      File.open(erb_file, 'r') do |file|
        erb_text = file.read
      end
      File.open(output_file, 'w') do |file|
        #erb = ERB.new(erb_text)
        #file.write(erb.result(binding))
        #eval(ERB.new(DATA.read).src, binding, __FILE__, __LINE__+2)
        file.write(eval(ERB.new(erb_text).src, binding, __FILE__, __LINE__ + 2))
      end
    end
  end
end
