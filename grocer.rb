def consolidate_cart(cart)
  # adds a count of one to each item when there are no duplicates
  hash_cart = {}
   cart.each do |info|
    info.each do |key, value|
      data_cart = hash_cart[key]
      if data_cart == nil
        data_cart = {}
        hash_cart[key] = value
        hash_cart[key][:count] = 1
      else
        hash_cart[key][:count] += 1
      end
    end
  end
  return hash_cart
end

def apply_coupons(cart, coupons)
  # code here
  hash_food = {}
  cart.each do |key, info|
    coupons.each do |coupon|
      if key == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if hash_food["#{key} W/COUPON"]
          hash_food["#{key} W/COUPON"][:count] += 1
        else
          hash_food["#{key} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    hash_food[key] = info
  end
  return hash_food
end

def apply_clearance(cart)
  # code here
  cart.each do |key, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.80).round(2)
    end
  end
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  coupons = apply_coupons(cart, coupons)
  clearance = apply_clearance(coupons)

   sum = 0
  clearance.each do |key, v|
    sum += (v[:count] * v[:price])
  end
   if sum > 100
    sum = sum * 0.90
  end
   sum.round(2)
end
