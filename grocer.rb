require 'pry'

cart = [
      {"AVOCADO" => {:price => 3.00, :clearance => true}}
]

coupons = []

def consolidate_cart(cart)
  assorted_items = {}
  #variable to store information about the number of coupons we have 
  one_or_multiple = ""
  
  cart.each_with_index do |items,index|
  
    items.each do |item, data|
      
      if assorted_items[item] == nil 
        assorted_items[item] = {}
        data.each do |category,info|
          assorted_items[item][category] = info
        end
        assorted_items[item][:count] = 1
        
      else 
        assorted_items[item][:count] += 1 
      end
      
    end
  end
  
  assorted_items
end

def apply_coupons(cart, coupons = nil)
  #determine if we have a single coupon or not 
  if coupons.length == 1 
    single_coupon = true
  elsif coupons.length > 1 
    single_coupon = false 
  end
  
  #applying one coupon to the cart
  if single_coupon == true 
    
    item = ""
    coupons = coupons[0] 
    
    #find out which item we have a coupon for 
    cart.each do |item_name,properties|
      item = coupons[:item] if item_name == coupons[:item]
    end
    
    #apply coupons to cart 
    if item != "" && cart[item][:count] >= coupons[:num]
      new_key = "#{item} W/COUPON"
      cart[new_key] = {}
      cart[item][:count] -= coupons[:num]
      
      #create new key for the bundled item
      cart[new_key][:price] = coupons[:cost]
      cart[new_key][:clearance] = cart[item][:clearance]
      cart[new_key][:count] = 1 
      
    end
  #applying multiple coupons to the cart
  elsif single_coupon == false  
    couponed_items = {}
    
    #create and fill in a hash for our couponed items and the number of coupons for each item
    cart.each do |item,properties|
      coupons.each do |coupon|
        
        if coupon[:item] == item && coupon[:num] <= cart[item][:count]
          cart[item][:count] -= coupon[:num]
          
          new_key = "#{item} W/COUPON"
          
          #creating a placeholder for couponed items to copy and paste into the cart after iterations
          
          couponed_items[new_key] = {} if couponed_items[new_key] == nil 
          if couponed_items[new_key][:price] == nil && couponed_items[new_key][:clearance] == nil
            couponed_items[new_key][:price] = coupon[:cost] 
            couponed_items[new_key][:clearance] = cart[item][:clearance]
          end
          
          if couponed_items[new_key][:count] == nil 
            couponed_items[new_key][:count] = 1 
          else 
            couponed_items[new_key][:count] += 1 
          end
          cart.delete(item) if cart[item][:count] == 0
        end
      end
    end
  
    couponed_items.each do |item,details|
      cart[item] = {} if cart[item] == nil
      cart[item] = details
    end
  end
  cart 
end

def apply_clearance(cart)
  cart.each do |item,details|
    details[:price] = (details[:price] * 0.8).round(2) if details[:clearance] == true 
  end
  cart 
end

def checkout(cart, coupons)
  cart = consolidate_cart cart 
  cart = apply_coupons cart,coupons 
  cart = apply_clearance cart 
  
  total = 0.0
  cart.each do |item,details|
    total += details[:count] * details[:price]
  end
  total = 0.9 * total if total > 100
  total
end

puts checkout cart,coupons