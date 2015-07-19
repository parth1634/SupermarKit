require 'rails_helper'

describe Item, type: :model do
  describe 'name scoping' do
    it 'should find matching query' do
      item = create(:item, name: 'Softie Jam')
      search = Item.with_name('Jam')
      expect(search).to eq [item]
    end

    it 'should not find unmatched query' do
      search = Item.with_name('Spam')
      expect(search).to eq []
    end
  end

  describe 'calculating item cost' do
    before :each do
      @item = create(:item)
      @grocery = create(:grocery)
      @grocery.items << @item
      @item.grocery_item(@grocery).update_attribute(:price_cents, 100)
      @item.grocery_item(@grocery).update_attribute(:quantity, 2)
    end

    it 'returns the proper quantity' do
      expect(@item.quantity(@grocery)).to eq 2
    end

    it 'calculates total based on quantity' do
      expect(@item.total_price(@grocery)).to eq 2.00
    end
  end
end
