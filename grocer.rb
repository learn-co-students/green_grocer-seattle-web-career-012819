require "pry"

def consolidate_cart(cart)
  new_hash = {}

  cart.each do |element|
    if new_hash.keys.include?(element.keys.first) == false
      element[element.keys.first][:count] = 1
      new_hash[element.keys.first] = element[element.keys.first]
    else
      new_hash[element.keys.first][:count] += 1
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_hash = {}

  if coupons.size == 0
    return cart
  end

  cart.each do |k, v|
    coupon = coupons.find { |element| element[:item] == k}

    new_hash[k] = v

    if coupon != nil
      new_hash[k + " W/COUPON"] = {price: coupon[:cost], clearance: v[:clearance], count: (v[:count] / coupon[:num])}
      new_hash[k][:count] -= (coupon[:num] * new_hash[k + " W/COUPON"][:count])
    end
  end
  new_hash
end

def apply_clearance(cart)
  cart.each do |k,v|
    if v[:clearance] == true
      v[:price] -= (v[:price]*0.2)
    end
  end
end

def checkout(cart, coupons)
  total = 0.0
  apply_clearance(apply_coupons(consolidate_cart(cart), coupons)).each do |k, v|
      total += (v[:price] * v[:count])
  end

  if total > 100
    total -= total*0.1
  end

  total
end
