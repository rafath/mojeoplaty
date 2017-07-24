class AmountInWords

  JEDNOSTKI = %w(e jeden dwa trzy cztery pięć sześć siedem osiem dziewięć)
  DZIESIATKI = %w(e dziesięć dwadzieścia trzydzieści czterdzieści pięćdziesiąt sześćdziesiąt siedemdziesiąt osiemdziesiąt dziewięćdziesiąt)
  NASTKI = %w(dziesięć jedenaście dwanaście trzynaście czternaście piętnaście szesnaście siedemnaście osiemnaście dziewiętnaście)
  SETKI = %w(e sto dwieście trzysta czterysta pięćset sześćset siedemset osiemset dziewięćset)
  WIELKIE = [
      %w(x x x),
      %w(tysiąc tysiące tysięcy),
      %w(milion miliony milionów),
      %w(miliard miliardy miliardów)
  ]
  ZLOTOWKI = %w(złoty złote złotych)
  GROSZE = %w(grosz grosze groszy)

  def three_digits_in_words(num)
    je = num % 10
    dz = (num / 10) % 10
    se = (num / 100) % 10
    slowa = []

    slowa << SETKI[se] if se > 0
    if dz == 1
      slowa << NASTKI[je]
    else
      slowa << DZIESIATKI[dz] if dz > 0
      slowa << JEDNOSTKI[je] if je > 0
    end
    slowa.join ' '
  end

  def grammatical_cases(num)
    je = num % 10
    dz = (num / 10) % 10

    if num == 1
      typ = 0 # jeden tysiąc
    elsif dz == 1 && je > 1
      typ = 2 # naście tysięcy
    elsif je >= 2 && je <= 4
      typ = 1 # [k-dziesiąt/set] [dwa/trzy/czery] tysiące
    else
      typ = 2 #tysiecy
    end
    typ
  end

  def translate(num)
    # liczba calkowita slownie
    trojki, slowa = [], []

    return 'zero' if num == 0
    while num > 0
      trojki << num % 1000
      num = num / 1000
    end

    trojki.each_with_index do |n, i|
      if n > 0
        if i > 0
          p = grammatical_cases(n)
          slowa << "#{three_digits_in_words(n)} #{WIELKIE[i][p]}"
        else
          slowa << three_digits_in_words(n)
        end
      end
    end
    slowa.reverse.join(' ')
  end

  #   num
  #   things = [coś, cosie, cosików]
  def anything_in_words(num, things=[])

    [translate(num), things[grammatical_cases(num)]].join(' ')
  end

  # fmt = 0 -> gr xx/100
  def translate_price(num, fmt=0)
    zloty = num.to_i
    # grosze = (num*100+0.5).to_i % 100
    grosze = (num*100).to_i % 100
    if fmt.zero?
      groszeslownie = '%d/100 gr' % grosze
    else
      groszeslownie = anything_in_words(grosze, GROSZE)
    end
    [anything_in_words(zloty, ZLOTOWKI), groszeslownie].join(' i ')
  end
end