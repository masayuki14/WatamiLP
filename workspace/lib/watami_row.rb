# -*- encoding: utf-8 -*-
require 'erb'

module Watami
  class Row

    ### class methods
    class << self

      ### class instance members
      attr_accessor :index_to_attr, :master_data

      ### CSVファイルをロードしてRowクラスの配列にする
      def parse(source_csv_file)
        Encoding.default_external = 'UTF-8'
        line = 0
        rows = []
        CSV.foreach(source_csv_file, encoding: "Shift_JIS:UTF-8") do |row|
          line += 1

          # 1行目は属性名の定義
          if line == 1
            set_attributes(row)
            next
          end

          # 2行目は属性の説明
          # 今のところ使う予定はない
          next if line == 2

          # インスタンスにする！
          rows << Watami::Row.new(row)
        end

        return rows
      end

      ### マスタデータを読み込んでクラスインスタンス変数に格納
      def load_master(master_dir)
        @master_data ||= {}

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
        @index_to_attr ||= {}
        attributes.each_with_index do |attr, index|
          next if attr.nil?
          attr_accessor attr # attrへのアクセッサ

          if @master_data[attr]
            # マスタがある場合はそのHashを返す
            # read メソッドをアラウンドエイリアスで上書き定義
            alias_method("origin_#{attr}", attr)
            define_method(attr) do
              value = self.send("origin_#{attr}") # 設定値取得
              self.class.master_data[attr][value]
            end
          end
          @index_to_attr[index] = attr
        end
      end
    end


    ### instance methods

    def initialize(data)
      data.each_index do |index|
        attr = self.class.index_to_attr[index]
        next if attr.nil? || attr.empty?
        self.send("#{attr}=", data[index])
      end
    end

    ### erb_file にデータをバインドしてブロックに返す
    def bind_erb(erb_file)
      File.open(erb_file, 'r') do |file|
        yield(ERB.new(file.read).result(binding))
      end
    end

    ### :attr 形式の文字列をその値に起きかえる
    # :category/:shopid/index.html -> watami/44/index.html
    def replace_by_attr(str)
      # 先頭が':'で始まるとSymbolになるので戻す
      if str.class == Symbol
        str = ':' + str.to_s
      end

      self.class.index_to_attr.values.reduce(str) do |result, attr|
        # マスタの場合は設定値にする
        value = self.send(attr)
        value = self.send("origin_#{attr}") if value.class == Hash || value.class == Array
        return result if value.nil?
        result.sub(Regexp.new("(:#{attr})"), value)
      end
    end
  end
end
