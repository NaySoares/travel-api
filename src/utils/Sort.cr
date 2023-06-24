class SortBy
  def self.groupBy(array : Array(T), &block : T -> K) forall T, K
    result = Hash(K, Array(T)).new

    array.each do |element|
      key = block.call(element)
      result[key] ||= [] of T
      result[key] << element
    end

    result
  end
end