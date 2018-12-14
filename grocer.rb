def consolidate_cart(cart)
  output_hash = {}
  cart.each do |cart_hash|
    cart_hash.each do |item_key, item_hash|
      item_hash.each do |attrib_key, attrib_val|
        if output_hash[item_key] == nil
          output_hash[item_key] = {}
          output_hash[item_key][:count] = 0
        end
        if output_hash[item_key][attrib_key] == nil
          output_hash[item_key][attrib_key] = attrib_val
        end
      end
      output_hash[item_key][:count] += 1
    end
  end
  output_hash
end

def apply_coupons(cart, coupons)
  #
  # Wow. You weren't kidding when you said this section was advanced.
  #
  # This function is very complicated to figure out logically.
  # These comments are as much a way for me to understand it as they are an explanation.
  #

  coupons.each do |promo_code|    # Iterate over the coupons array
    promo_item_hash = {:count => 0}   # Generate an empty hash based on each coupon item
    item_with_coupon = nil        # Initialize a string of "<ITEM> W/COUPON", left empty for now
    num_required_for_coupon = nil     # Initialize a number required for a coupon to be applied
    promo_code.each do |promo_key, promo_val| # Iterate over the nested hash
      if promo_key == :item       # If we are looking at the :item key
          # Programmatically generate the "<ITEM> W/COUPON" string (cleanly, no hard code)
        item_with_coupon = [promo_val, "w/coupon".upcase].join(" ")
      elsif promo_key == :num     # If we are looking at the :num key
        num_required_for_coupon = promo_val       # Store the number this item needs for a coupon to apply
      elsif promo_key == :cost    # If we are looking at the :cost key
        if promo_item_hash[:price] == nil         # If we have not added a :price key yet
          promo_item_hash[:price] = promo_val     # Assign the value of promo_val to new key :price
        end
      end
    end
    run_update_count_loop = false # Initialize whether to update counts for this item
    key_to_remove = nil           # Initialize whether the original item key needs removing
    cart.each do |hash_key, hash_val| # Iterate over the consolidated cart data
        # If we have found a possible match and it is not the added coupon item
      if item_with_coupon.start_with?(hash_key) && !hash_key.downcase.include?("w/")
        hash_val.each do |nested_key, nested_val| # Iterate over each nested hash
          if nested_key == :clearance && promo_item_hash[nested_key] == nil # If we have not yet added a :clearance key
            promo_item_hash[nested_key] = nested_val    # Assign nested_val to new key :clearance
          elsif nested_key == :count  # If we are checking the :count key of this item
            if num_required_for_coupon != nil     # If the number of items required has been stored
              if nested_val >= num_required_for_coupon  # If the :count of this item meets or exceeds the amount needed
                run_update_count_loop = true      # Raise the condition we should update counts
              end
            end
            if run_update_count_loop  # If we have been instructed to update counts
              until cart[hash_key][nested_key] < num_required_for_coupon # Until the :count of this item is below the amount needed
                promo_item_hash[nested_key] += 1  # Increment the :count of the promo_item_hash by 1
                cart[hash_key][nested_key] -= num_required_for_coupon # Decrement the :count of this eligible item by the amount needed
              end
              if nested_val == 0      # If the :count for this item reached zero
                key_to_remove = hash_key          # Record the key of the item to be removed
              end
            end
          end
        end
      end
    end
    if promo_item_hash[:count] > 0    # If we found at least one match
      if cart[item_with_coupon] == nil            # If we have not yet added the item with the coupon applied
        cart[item_with_coupon] = promo_item_hash  # Add the item with coupon applied
      end
    end
    if key_to_remove != nil # If we found a key to remove due to a :count of zero
      cart.delete(key_to_remove)      # Delete the key from the cart hash
    end
  end
  cart  # Return the updated consolidated cart hash
end

def apply_clearance(cart)
  cart.each do |hash_key, hash_val|
    item_is_20_percent_off = false
    key_to_modify = nil
    hash_val.each do |nested_key, nested_val|
      if nested_key == :price
        key_to_modify = nested_key
      elsif nested_key == :clearance && nested_val
        item_is_20_percent_off = true
      end
    end
    if item_is_20_percent_off && key_to_modify != nil
      cart[hash_key][key_to_modify] = (cart[hash_key][key_to_modify] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  shopping_trip = consolidate_cart(cart)
  shopping_trip = apply_coupons(shopping_trip, coupons)
  shopping_trip = apply_clearance(shopping_trip)
  grand_total = 0
  shopping_trip.each do |hash_key, hash_val|
    sum_of_item_type = 0
    item_count = nil
    item_price = nil
    hash_val.each do |nested_key, nested_val|
      if nested_key == :count
        item_count = nested_val
      elsif nested_key == :price
        item_price = nested_val
      end
    end
    sum_of_item_type = item_count * item_price
    grand_total += sum_of_item_type.round(2)
  end
  if grand_total > 100.00
    grand_total *= 0.9
  end
  grand_total
end
