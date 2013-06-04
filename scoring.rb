# Still need to add support for extra frames at the end

class Bowl

    attr_accessor :frames, :score

    def initialize
        @score = 0
    end

    
    def add(*frames)
        i = 0
        while i < frames.length
            frame = frames[i]
            total = frame.reduce(:+)
            if total < 10 # count the pins
                @score += total
            elsif frame.length == 2 # spare
                @score += 10 + frames[i + 1][0]
            else # strike
                if frames[i + 1].length == 2 # stike followed by non-strike
                    @score += 10 + frames[i + 1][0] + frames[i + 1][1]
                else # strike followed by another strike
                    @score += 10 + frames[i + 1][0] + frames[i + 2][0]
                end
            end
            i += 1
        end
    end

end
