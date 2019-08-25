BACKSTAGE_PASSES = 'Backstage passes to a TAFKAL80ETC concert'.freeze
AGED_BRIE = 'Aged Brie'.freeze
SULFURAS =  'Sulfuras, Hand of Ragnaros'.freeze

def update_quality(items)
  items.each do |item|
    decrease_days!(item)

    advance_quality!(item)

    lower_bound_quality!(item)
    upper_bound_quality!(item)
  end
end

def lower_bound_quality!(item)
  item.quality = 0 if item.quality < 0
end

def upper_bound_quality!(item)
  max_quality = item.name == SULFURAS ? 80 : 50

  item.quality = max_quality if item.quality > max_quality
end

def decrease_days!(item)
  item.sell_in -= 1 unless item.name == SULFURAS
end

def advance_quality!(item)
  case item.name
  when BACKSTAGE_PASSES
    if item.sell_in < 0
      item.quality = 0
    elsif item.sell_in < 5
      item.quality += 3
    elsif item.sell_in < 10
      item.quality += 2
    else
      item.quality += 1
    end
  when AGED_BRIE
    item.quality += passed_date?(item) ? 2 : 1
  when SULFURAS
    item.quality = item.quality
  else
    item.quality -= passed_date?(item) ? 2 : 1
  end
end

def passed_date?(item)
  item.sell_in < 0
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

