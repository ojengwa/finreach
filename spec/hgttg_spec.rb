require "hgttg"
require "numeral"


RSpec.describe HitchHiker, "#test" do
  context "with nothing inside"  do
    it "Checks nothing." do
      expect(true).to eq(true)
    end
  end
end

RSpec.describe Numeral, "#initialize" do
  context "Checks that the numeral search works" do
      it 'returns a matched substring' do
        numeral = Numeral.new("ab")
        expect(numeral.match("abcde")).to include("ab")
      end

      it "returns multiple matched substrings" do
        numeral = Numeral.new("ab", "cd")
        expect(numeral.match("cd123ab").to_set).to eq ["ab", "cd"].to_set
      end

      it "returns overlapping matched substrings" do
        numeral = Numeral.new("ab", "bc")
        expect(numeral.match("abc").to_set).to eq ["ab", "bc"].to_set
      end

      it "does not return unmatched substrings" do
        numeral = Numeral.new("ab")
        expect(numeral.match("abc")).not_to include("bc")
      end

      it "matches adjacent terms" do
        numeral = Numeral.new("ab", "cd")
        expect(numeral.match("abcd").to_set).to eq ["ab", "cd"].to_set
      end

      it "matches terms directly following a partial match" do
        numeral = Numeral.new("abc", "de")
        expect(numeral.match("ade")).to include("de")
      end

      it "returns terms added to the matcher after instantiation" do
        numeral = Numeral.new("ab")
        numeral.insert("cd", "ef")
        expect(numeral.match("ab12cd12ef").to_set).to eq ["ab", "cd", "ef"].to_set
      end

      it "allows instantiation with an array of terms" do
        numeral = Numeral.new(["ab", "c", "cd"])

        puts numeral.match("abcd")
        expect(numeral.match("abcd")).to include("ab")
      end

      it "allows insert with an array of terms" do
        numeral = Numeral.new("ab")
        numeral.insert(["cd"])
        expect(numeral.match("abcd")).to include("cd")
      end

      it "returns overlapping matched substrings correctly" do
        numeral = Numeral.new(["cd", "d", "abce"])
        expect(numeral.match("abcd").to_set).to eq ["cd", "d"].to_set
      end
  end

end