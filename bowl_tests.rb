require "./scoring"

describe Frame do
    context "score for an unclean frame" do
        it "calculates the number of pins" do
            frame = Frame.new
            frame.roll(3)
            frame.roll(4)
            frame.score.should == 7
        end
    end
end


describe TenPin do
    context "a single roll" do
        it "sets the first ball of the first frames" do
            game = TenPin.new
            game.roll(3)
            game.frames[0].balls[0].should == 3
        end
    end
    context "two rolls" do
        it "sets both balls in the first frame" do
            game = TenPin.new
            game.roll(3)
            game.roll(4)
            game.frames[0].balls[0].should == 3
            game.frames[0].balls[1].should == 4

        end
    end
    context "three rolls" do
        it "sets both balls in the first frame, and the first ball in the second frame" do
            game = TenPin.new
            game.roll(3)
            game.roll(4)
            game.roll(7)
            game.frames[0].balls[0].should == 3
            game.frames[0].balls[1].should == 4
            game.frames[1].balls[0].should == 7

        end
    end
    context "three rolls with a strike" do
        it "sets a strike in the first frame, two balls in the second frame" do
            game = TenPin.new
            game.roll(10)
            game.roll(4)
            game.roll(3)
            game.frames[0].balls[0].should == 10
            game.frames[0].balls[1].should == nil
            game.frames[1].balls[0].should == 4
            game.frames[1].balls[1].should == 3

        end
    end
    context "score for a spare followed by a non-strike" do
        it "adds 10 + first ball of the second frame" do
            game = TenPin.new
            [3, 7, 4, 5].each {|pins| game.roll(pins)}
            game.frames[0].score.should == 14
            game.frames[1].score.should == 9
        end
    end
    context "score for a spare followed by a strike" do
        it "equals 20" do
            game = TenPin.new
            [3, 7, 10].each {|pins| game.roll(pins)}
            game.frames[0].score.should == 20
        end
    end
    context "score for a strike followed by an unclean frame" do
        it "equals 10 + next two balls" do
            game = TenPin.new
            [10, 3, 5].each {|pins| game.roll(pins)}
            game.frames[0].score.should == 18
            game.frames[1].score.should == 8
        end
    end
    context "score for a strike followed by a spare" do
        it "equals 20" do
            game = TenPin.new
            [10, 6, 4].each {|pins| game.roll(pins)}
            game.frames[0].score.should == 20

        end
    end
    context "score for a strike followed by one strike and one non-strike" do
        it "equals 20 + first ball of last frame" do
            game = TenPin.new
            [10, 10, 7, 2].each {|pins| game.roll(pins)}
            game.frames[0].score.should == 27
        end
    end
    context "score for a strike followed by two strikes" do
        it "equals 30" do
            game = TenPin.new
            [10, 10, 10].each {|pins| game.roll(pins)}
            game.frames[0].score.should == 30
        end
    end
end