

class Frame

    attr_reader :balls
    attr_accessor :score, :next

    def initialize
        @balls = Array.new(size=2)
    end

    def roll(pins)
        if (@balls[0] and @balls[1]) or (balls[0] and balls[0] + pins > 10)
            raise "This frame is finished"
        elsif @balls[0]
            balls[1] = pins
        else
            balls[0] = pins
        end
    end

    def score
        total = if balls[1]
                    balls.reduce(:+)
                else
                    balls[0]
                end
        if total < 10 # neither strike nor spare
            return total
        elsif @balls[0] < 10 # spare
            if @next
                return total + @next.balls[0]
            end
        else
            if @next and @next.balls[0] < 10 # strike followed by a non-strike
                return total + @next.balls.reduce(:+)
            elsif @next and @next.next # strike followed by a strike
                return total + @next.balls[0] + @next.next.balls[0]
            end
        end
    end
end

class TenPin
    # overload indexing, on this or on Frame
    # frame.is_spare and frame.is_strike

    attr_accessor :frames

    def initialize
        @frames = [Frame.new]
        @current_frame = @frames[0]
    end

    def roll(pins)
        # we know that there should be no more rolls when:
        # => the 10th frame had two balls that resulted in neither a spare nor a strike
        # => the 10th frame had a spare, and one ball was rolled in the 11th frame
        # => the 10th frame had a strike, and either:
        # => => two non-strike balls were rolled in the 11th frame
        # => => one strike was rolled in the 11th frame and one additional ball was rolled in the 12th


        if frames.length >= 10
            self.ending
        end
        begin
            @current_frame.roll(pins)
        rescue Exception => e
            @frames << Frame.new
            @current_frame.next = @frames[-1]
            @current_frame = @frames[-1]
            @current_frame.roll(pins)
        end
    end

    def ending
        tenth = @frames[9]
        # if two balls have been rolled in the 10th frame and did not result in a strike or spare
        if tenth.balls[0] and tenth.balls[1] and tenth.balls.reduce(:+) < 10
            raise "The game is over"
        # if a strike was rolled in the 10th frame and two additional balls have been rolled
        elsif tenth.balls[0] == 10 and 
            ((tenth.next.balls[0] and tenth.next.balls[1]) or (tenth.next.balls[0] == 10 and tenth.next.next.balls[0]))
            raise "The game is over"
        # if a spare was rolled in the 10th frame and one additional ball has been rolled
        elsif tenth.balls[0] and tenth.balls[1] and tenth.balls.reduce(:+) == 10 and tenth.next.balls[0]
            raise "The game is over"
        # otherwise, the game is still valid to play
        else
            return nil
        end
    end


end