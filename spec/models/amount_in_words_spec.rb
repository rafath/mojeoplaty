require 'rails_helper'

describe 'AmountInWords' do

  it 'translates number to words' do

    words = AmountInWords.new

    expect(words.three_digits_in_words(213)).to eq 'dwieście trzynaście'
    expect(words.three_digits_in_words(100)).to eq 'sto'
    expect(words.three_digits_in_words(151)).to eq 'sto pięćdziesiąt jeden'
    expect(words.three_digits_in_words(1)).to eq 'jeden'
    expect(words.three_digits_in_words(2)).to eq 'dwa'
    expect(words.three_digits_in_words(120)).to eq 'sto dwadzieścia'
    expect(words.three_digits_in_words(12)).to eq 'dwanaście'
    expect(words.three_digits_in_words(20)).to eq 'dwadzieścia'
    expect(words.three_digits_in_words(999)).to eq 'dziewięćset dziewięćdziesiąt dziewięć'

    expect(words.translate(0)).to eq 'zero'
    expect(words.translate(2000)).to eq 'dwa tysiące'
    expect(words.translate(50)).to eq 'pięćdziesiąt'
    expect(words.translate(12000)).to eq 'dwanaście tysięcy'

    expect(words.anything_in_words(235, %w(telefon telefony telefonów))).to eq 'dwieście trzydzieści pięć telefonów'
    expect(words.anything_in_words(230, %w(telefon telefony telefonów))).to eq 'dwieście trzydzieści telefonów'
    expect(words.anything_in_words(231, %w(telefon telefony telefonów))).to eq 'dwieście trzydzieści jeden telefonów'
    expect(words.anything_in_words(233, %w(telefon telefony telefonów))).to eq 'dwieście trzydzieści trzy telefony'

    expect(words.translate_price(1.5)).to eq 'jeden złoty i 50/100 gr'
    expect(words.translate_price(1.5, 1)).to eq 'jeden złoty i pięćdziesiąt groszy'
    expect(words.translate_price(1.51, 1)).to eq 'jeden złoty i pięćdziesiąt jeden groszy'
    expect(words.translate_price(1.54, 1)).to eq 'jeden złoty i pięćdziesiąt cztery grosze'

    expect(words.translate_price(1234.98)).to eq 'jeden tysiąc dwieście trzydzieści cztery złote i 98/100 gr'
    expect(words.translate_price(1234.98, 1)).to eq 'jeden tysiąc dwieście trzydzieści cztery złote i dziewięćdziesiąt osiem groszy'
    expect(words.translate_price(1230.98, 1)).to eq 'jeden tysiąc dwieście trzydzieści złotych i dziewięćdziesiąt osiem groszy'

  end

end