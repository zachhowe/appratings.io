module AppRatings
  class RatingUtil
    def self.weighted_mean(ratings)
      a = Array.new
      ratings.each_pair do |name, val|
        a << [name.to_i, val.to_i]
      end

      mean = a.reduce(0) { |m,r| m += r[0] * r[1] } / a.reduce(0) { |m,r| m += r[1] }.to_f
      mean /= a.count

      mean
    end

    def self.weighted_mean_legacy(ratings)
      b7 = 0
      c7 = 0

      ratings.each_pair do |name, val|
        b7 += val.to_i
        c7 += val.to_i * name.to_i
      end

      d7 = b7 * 5
      ratio = c7.to_f / d7.to_f

      ratio
    end
  end
end
