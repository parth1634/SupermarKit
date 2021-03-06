require 'rails_helper'

RSpec.describe GroceriesItems, type: :model do
  describe '#estimated_price' do
    let(:item) { create(:item) }
    let(:grocery) { create(:grocery, items: [item], grocery_store: current_store) }
    let(:grocery_item) { item.grocery_item(grocery) }
    let(:store_name) { 'Safeway' }
    let(:nearby_store_name) { 'Safeway' }
    let(:current_store) { create(:grocery_store, lat: 43, lng: -80, name: store_name) }
    let(:nearby_store) { create(:grocery_store, lat: 44, lng: -80, name: nearby_store_name) }

    before(:each) do
      groceries = create_list :grocery, 3, items: [item], grocery_store: nearby_store
      item.grocery_item(groceries[0]).update_attribute(:price_cents, 500)
      item.grocery_item(groceries[1]).update_attribute(:price_cents, 100)
      item.grocery_item(groceries[2]).update_attribute(:price_cents, 500)

      other_groceries = create_list :grocery, 3, items: [item]
      other_groceries.each do |grocery|
        item.grocery_item(grocery).update_attribute(:price_cents, 50)
      end
    end

    context 'with a store' do
      context 'with a nearby store' do
        context 'with the same name' do
          it 'should assign the most common price from the nearby store' do
            expect(grocery_item.estimated_price.fractional).to eq 500
          end

          it 'should fallback on the general most common price of outside closeness threshold' do
            create_list :grocery_store, 9, lat: 43, lng: -80, name: 'Safeway'
            expect(grocery_item.estimated_price.fractional).to eq 50
          end
        end

        context 'without the same name' do
          let(:nearby_store_name) { 'Sobeys' }
          it 'should fallback on the general most common price' do
            expect(grocery_item.estimated_price.fractional).to eq 50
          end
        end
      end

      context 'without a nearby store' do
        let(:nearby_store) { nil }
        it 'should fallback on the general most common price' do
          expect(grocery_item.estimated_price.fractional).to eq 50
        end
      end
    end
  end

  describe '#total_price' do
    let(:item) { create(:item) }
    let(:grocery) { create(:grocery, items: [item]) }
    let(:grocery_item) { item.grocery_item(grocery) }

    context 'with price' do
      it 'should return the quantity times the price' do
        grocery_item.update({ price_cents: 500, quantity: 2 })
        expect(grocery_item.total_price_or_estimated.fractional).to eq 1000
      end
    end

    context 'without price' do
      it 'should return the quantity times the price using the estimated price' do
        other_grocery = create(:grocery, items: [item])
        grocery_item.update({ quantity: 2 })
        item.grocery_item(other_grocery).update_attribute(:price_cents, 100)
        expect(grocery_item.total_price_or_estimated.fractional).to eq 200
      end
    end
  end

  describe '#price_or_estimated' do
    let(:item) { create(:item) }
    let(:grocery) { create(:grocery, items: [item]) }
    let(:grocery_item) { item.grocery_item(grocery) }

    context 'with a price' do
      it 'should return the price' do
        grocery_item.update_attribute(:price_cents, 500)
        expect(grocery_item.price_or_estimated.fractional).to eq 500
      end
    end

    context 'without a price' do
      it 'should return the estimated price' do
        other_grocery = create(:grocery, items: [item])
        item.grocery_item(other_grocery).update_attribute(:price_cents, 500)
        expect(grocery_item.price_or_estimated.fractional).to eq 500
      end
    end
  end
end
