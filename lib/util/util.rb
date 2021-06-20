require 'active_support/inflector'

module Util
  def self.parse_package(package)
    result = {}
    last_key = nil
    package.each_line do |line|
      detail = line.split(':')

      # if after splitting, the array has > 1 length
      # means that we have a key, value pair if not use
      # the last key.
      if detail.length > 1
        key, value = detail
        last_key = key.underscore.to_sym
        result[last_key] = value.strip
      else
        result[last_key] += " #{detail[0].strip}"
      end
    end

    result
  end
end
