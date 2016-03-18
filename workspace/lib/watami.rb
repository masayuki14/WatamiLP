# -*- encoding: utf-8 -*-

module Watami
  class Row

    ### class instance members
    @attr_to_index = {}
    @index_to_attr = {}
    @descriptions  = {}


    ### class methods
    class << self

      ### 属性の定義
      # attributes = ['name', 'shop'] の場合
      # name, name=, shop, shop= のアクセッサを定義する
      def set_attributes(attributes)
        attributes.each_index do |index|
          attr = attributes[index]
          attr_accessor attr
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
    end


    ### instance methods

    def initialize(data)
      data.each_index do |index|
        attr = self.class.index_to_attr[index]
        self.send("#{attr}=", data[index])
      end
    end
  end
end
