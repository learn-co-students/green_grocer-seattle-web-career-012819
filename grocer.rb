# cart = [
#   {"AVOCADO" => {:price => 3.0, :clearance => true }},
#   {"AVOCADO" => {:price => 3.0, :clearance => true }},
#   {"KALE"    => {:price => 3.0, :clearance => false}}
# ]

# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
# }

def consolidate_cart(cart)
  consolidated_cart = {}
  removed_duplicates = cart.uniq
  removed_duplicates.each do |item|
    count = cart.count(item)
    item_name = item.keys[0]
    item[item_name][:count] = count
    consolidated_cart[item_name] = item[item_name]
  end
  consolidated_cart
end

cart = {
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
}

coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.0},
           {:item => "KALE", :num => 1, :cost => 1.0}]

# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
#   "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},
# }

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]

      cart[coupon[:item]][:count] -= coupon[:num]
      coupon_name = "#{coupon[:item]} W/COUPON"

      if cart.key?(coupon_name)
        cart[coupon_name][:count] += 1
      else
        cart[coupon_name] = { 
          price: coupon[:cost], 
          clearance: cart[coupon[:item]][:clearance], 
          count: 1
        }
      end
    end
  end
  cart
end

# p apply_coupons(cart, coupons)

def apply_clearance(cart)
  cart.each do |item, properties|
    if properties[:clearance]
      cart[item][:price] = (properties[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  
  consolidated_cart = consolidate_cart(cart)
  discounted_cart = apply_coupons(consolidated_cart, coupons)
  clearance_discounted_cart = apply_clearance(discounted_cart)
  
  clearance_discounted_cart.each do |item, properties|
    total += properties[:price] * properties[:count]
  end
  if total > 100
    total *= 0.9
    total.round(2)
  end
  total
end
