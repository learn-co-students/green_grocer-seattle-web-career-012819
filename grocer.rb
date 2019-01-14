require 'pry'

def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item|
    item.each do |name, info|
      if consolidated_cart[name]
        consolidated_cart[name][:count] += 1
      else
        consolidated_cart[name] = info.merge({:count => 1})
      end
    end
  end
  #puts consolidated_cart
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    discount_name = item_name + " W/COUPON"
    if cart.include?(item_name) && cart[item_name][:count] >= coupon[:num]
      cart[discount_name] = {:count => 0} if (!cart.include?(discount_name))
      cart[discount_name][:price] =  coupon[:cost]
      #cart[discount_name][:count] += [coupon[:num],cart[item_name][:count]].min
      cart[discount_name][:count] += 1  #???????????
      #binding.pry
      cart[item_name][:count] = [cart[item_name][:count] - coupon[:num],0].max
      cart[discount_name][:clearance] = cart[item_name][:clearance]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each_value do |item_info|
    item_info[:price] -= item_info[:price]*0.2 if item_info[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each_value {|item| item[:count].times {total += item[:price] }}
  total -= total*0.1 if total >= 100
  total
end
