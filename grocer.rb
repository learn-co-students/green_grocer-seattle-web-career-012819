def consolidate_cart(cart)
  new_cart = {}
  cart.each do |x|
    x.each do |item, info_hash|
      #check to see if item name already exists in new_cart/if not add
      if new_cart[item].nil?
        new_cart[item] = info_hash.merge({:count => 1})
      else
        new_cart[item][:count] += 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |x|
    item = x[:item]
    if cart.has_key?(item) == true && cart[item][:count] >= x[:num]
      cart[item][:count] = cart[item][:count] - x[:num]
      new_name = item + (" W/COUPON")
      puts cart.has_key?(new_name)
      if cart.has_key?(new_name) == false 
        cart[new_name] = {:price => x[:cost], :clearance => cart[item][:clearance], :count => 1}
      else 
        cart[new_name][:count] += 1 
      end
    end
  end
  cart
end

def apply_clearance(cart)
  control_cart = cart 
  cart.each do |item, hash|
    if hash[:clearance] == true 
      control_cart[item][:price] = (cart[item][:price]*0.8).round(2)
    end
  end
  control_cart
end

def checkout(cart, coupons)
  control_cart = consolidate_cart(cart)
  apply_coupons(control_cart,coupons)
  apply_clearance(control_cart)
  count = 0 
    control_cart.each do |item, hash|
      count += (hash[:price]*hash[:count])
    end
  if count >= 100
    count *=0.9
  end
  count 
  
end
