

class Frame
    # TODO: overload indexing, on this or on Frame
    # TODO: frame.is_spare and frame.is_strike

    attr_reader :balls
    attr_accessor :score, :next

    def initialize
        @balls = Array.new(size=2)
    end

    def [](index)
        @balls[index]
    end

    def finished?
        !(@balls[0].nil? or (@balls[1].nil? and @balls[0] < 10))
    end
    
    def strike?
        @balls[0] == 10
    end

    def spare?
        self.finished? and !(self.strike?) and @balls.reduce(:+) == 10
    end

    def unclean?
        self.finished? and !(self.strike?) and @balls.reduce(:+) < 10
    end

    def roll(pins)
        if self.finished?
            raise "This frame is finished"
        elsif @balls[0]
            balls[1] = pins
        else
            balls[0] = pins
        end
    end

    def score
        total = if balls[1] then balls.reduce(:+) else balls[0] end
        if self.unclean?
            return total
        elsif self.spare? and @next
            return total + @next[0]
        else
            if @next and @next.finished? and !(@next.strike?) # strike followed by a non-strike
                return total + @next.balls.reduce(:+)
            elsif @next and @next.strike? and @next.next # strike followed by a strike followed by another frame
                return total + @next[0] + @next.next[0]
            end
        end
    end
end

class TenPin

    attr_accessor :frames

    def initialize
        @frames = [Frame.new]
        @current_frame = @frames[0]
    end

    def roll(pins)
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
        if tenth.unclean?
            raise "The game is over"
        # if a strike was rolled in the 10th frame and two additional balls have been rolled
        elsif tenth.strike? and tenth.next and 
            ((tenth.next.unclean? or tenth.next.spare?) or 
            (tenth.next.strike? and tenth.next.next and tenth.next.next.strike?))
            raise "The game is over"
        # if a spare was rolled in the 10th frame and one additional ball has been rolled
        elsif tenth.spare? and tenth.next and tenth.next.balls[0]
            raise "The game is over"
        # otherwise, the game is still valid to play
        else
            return nil
        end
    end


end