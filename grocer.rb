require 'pry'
def consolidate_cart(cart)
  hash_cart = {}
  cart.each do |item|
    hash_cart[item.keys[0]] ||= item[item.keys[0]]
    hash_cart[item.keys[0]][:count] ||= 0
    hash_cart[item.keys[0]][:count] += 1
  end
  hash_cart
end

def apply_coupons(hash_cart, coupons)
  coupons.each do |coupon|
    if hash_cart[coupon[:item]] && hash_cart[coupon[:item]][:count] >= coupon[:num]
      hash_cart[coupon[:item]][:count] -= coupon[:num]
      hash_cart["#{coupon[:item]} W/COUPON"] ||= {}
      hash_cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
      hash_cart["#{coupon[:item]} W/COUPON"][:count] ||= 0
      hash_cart["#{coupon[:item]} W/COUPON"][:count] += 1
      hash_cart["#{coupon[:item]} W/COUPON"][:clearance] = hash_cart[coupon[:item]][:clearance]
    end
  end
  hash_cart
end

def apply_discount(hash_cart, discount)
  hash_cart.each do |name, item|
    if item[:clearance]
      item[:price] = ('%.2f' % (item[:price] * discount)).to_f
      hash_cart[name] = item
    end
  end
  hash_cart
end

def apply_clearance(hash_cart)
  hash_cart.each do |name, item|
    if item[:clearance]
      item[:price] = ('%.2f' % (item[:price] * 0.8)).to_f
      hash_cart[name] = item
    end
  end
  hash_cart
end

def apply_ten(hash_cart)
  hash_cart.each do |name, item|
    item[:price] = ('%.2f' % (item[:price] * 0.9)).to_f
    hash_cart[name] = item
  end
  hash_cart
end

def sum_cart(hash_cart)
  sum = 0.0
  hash_cart.each do |name, item|
    sum += (item[:price] * item[:count])
  end
  sum
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  hash_cart = apply_coupons(hash_cart, coupons)
  hash_cart = apply_clearance(hash_cart)
  sum = sum_cart(hash_cart)

  if sum > 100.00
    hash_cart = apply_ten(hash_cart)
    sum = sum_cart(hash_cart)
  end
  sum
end
