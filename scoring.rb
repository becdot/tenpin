

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

    def []=(index, value)
        @balls[index] = value
    end

    def value
        self.balls.compact.reduce(:+)
    end

    def finished?
        !(self[0].nil? or (self[1].nil? and self[0] < 10))
    end
    
    def strike?
        self[0] == 10
    end

    def spare?
        self.finished? and !(self.strike?) and self.value == 10
    end

    def unclean?
        self.finished? and !(self.strike?) and self.value < 10
    end

    def roll(pins)
        if self.finished?
            raise "This frame is finished"
        elsif self[0]
            self[1] = pins
        else
            self[0] = pins
        end
    end

    def score
        if self.unclean?
            return self.value
        elsif self.spare? and self.next
            return self.value + self.next[0]
        else
            if self.next and self.next.finished? and !(self.next.strike?) # strike followed by a non-strike
                return self.value + self.next.balls.reduce(:+)
            elsif self.next and self.next.strike? and self.next.next # strike followed by a strike followed by another frame
                return self.value + self.next[0] + self.next.next[0]
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
        eleventh = tenth.next
        # if two balls have been rolled in the 10th frame and did not result in a strike or spare
        if tenth.unclean?
            raise "The game is over"
        # if a strike was rolled in the 10th frame and two additional balls have been rolled
        elsif tenth.strike? and eleventh and 
            ((eleventh.unclean? or eleventh.spare?) or 
            (eleventh.strike? and eleventh.next and eleventh.next.strike?))
            raise "The game is over"
        # if a spare was rolled in the 10th frame and one additional ball has been rolled
        elsif tenth.spare? and eleventh and eleventh[0]
            raise "The game is over"
        # otherwise, the game is still valid to play
        else
            return nil
        end
    end


end