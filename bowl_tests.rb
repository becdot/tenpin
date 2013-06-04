require "./scoring"

describe Bowl do
    context "a single non-clean frame" do
        it "calculates number of pins knocked down" do
            game = Bowl.new
            game.add([3, 4])
            game.score.should == 7

        end
    end
    context "a game with no strikes or spares" do
        it "adds the number of pins knocked down across all frames" do
            game = Bowl.new
            bad_game = [[3, 4], [6, 2], [5, 4], [1, 2], [2, 3], [8, 1], [9, 0], [7, 2], [0, 1], [8, 0]]
            game.add(*bad_game)
            game.score.should == bad_game.flatten.reduce(:+)
        end
    end
    context "a spare followed by a non-spare" do
        it "adds ten + next ball" do
            game = Bowl.new
            bad_spare_game = [[3, 7], [1, 2]] # [11, 3]
            game.add(*bad_spare_game)
            game.score.should == [11, 3].reduce(:+)
        end
    end
    context "a spare followed by a spare" do
        it "still adds ten + next ball" do
            game = Bowl.new
            two_spares = [[3, 7], [9, 1], [3, 4]] # [19, 13, 7]
            game.add(*two_spares)
            game.score.should == [19, 13, 7].reduce(:+)
        end
    end
    context "a strike followed by a bad frame" do
        it "adds ten + next two balls" do
            game = Bowl.new
            strike_meh = [[10], [3, 4]] # [17, 7]
            game.add(*strike_meh)
            game.score.should == [17, 7].reduce(:+)
        end
    end
    context "a strike followed by a spare" do
        it "adds twenty" do
            game = Bowl.new
            strike_spare = [[10], [3, 7], [1, 1]] # [20, 11, 2]
            game.add(*strike_spare)
            game.score.should == [20, 11, 2].reduce(:+)
        end
    end
    context "a strike followed by one strike and one non-strike" do
        it "adds twenty + next ball" do
            game = Bowl.new
            strike_strike = [[10], [10], [1, 1]] # [21, 12, 2]
            game.add(*strike_strike)
            game.score.should == [21, 12, 2].reduce(:+)
        end
    end
    context "a strike followed by two strikes" do
        it "adds twenty + next ball" do
            game = Bowl.new
            strike_strike_strike = [[10], [10], [10], [0, 0]] # [30, 20, 10, 0]
            game.add(*strike_strike_strike)
            game.score.should == [30, 20, 10, 0].reduce(:+)
        end
    end
end
