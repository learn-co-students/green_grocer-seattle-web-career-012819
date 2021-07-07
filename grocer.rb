def consolidate_cart(cart)
  cart_hash = {}
  
  cart.each do |element|
    element.each do |item, info|
      if cart_hash.key?(item) == false
        cart_hash[item] = {}
        info.each do |attributes, value|
          cart_hash[item][attributes] = value
        end
        cart_hash[item][:count] = 1
      else
        cart_hash[item][:count] += 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |item|
    item_array = item.flatten
    label = item_array[1] + " W/COUPON"
    if (cart.key?(item_array[1]) == true)
      if(cart[item_array[1]][:count] >= item_array[3])
        if (cart.key?(label) == false)
            cart[label] = {}
            cart[label][:price] = item_array[5]
            cart[label][:clearance] = cart[item_array[1]][:clearance]
            cart[item_array[1]][:count] -= item_array[3]
            cart[label][:count] = 1
        else
            cart[label][:count] += 1
            cart[item_array[1]][:count] -= item_array[3]
        end
      end
    end
  end
  
  #check to see if origonal count 0
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    info.each do |attribute, value|
      if (attribute == :clearance)
        if (value == true)
          price = cart[item][:price]
          cart[item][:price] = (price * 0.8).round(1)
        end
      end
    end
  end
  cart
end

def checkout(cart, coupons)
  organized_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(organized_cart, coupons)
  clearanced_cart = apply_clearance(couponed_cart)
  cart_total = 0 
  
  clearanced_cart.each do |item, info|
    item_total = clearanced_cart[item][:price] * clearanced_cart[item][:count]
    cart_total += item_total
  end
  
  if cart_total > 100
    cart_total = (cart_total * 0.9).round(1)
  end
  cart_total
end
