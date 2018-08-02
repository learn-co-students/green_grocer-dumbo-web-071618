require 'pry'

def consolidate_cart(cart)
  revised_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item,attributes|
      #binding.pry
      if !revised_cart[item]
        revised_cart[item] = attributes
        revised_cart[item][:count] = 1
      else
        revised_cart[item][:count] += 1
      end
    end
  end
  revised_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    item = coupon_hash[:item]
    if cart.has_key?(item)
      if cart[item][:count] >= coupon_hash[:num]
        if !cart["#{item} W/COUPON"]
          cart["#{item} W/COUPON"] = {:price  => coupon_hash[:cost], :clearance => cart[item][:clearance], :count =>1}
        else
          cart["#{item} W/COUPON"][:count] += 1 
        end
        cart[item][:count] -= coupon_hash[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item,attributes|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.80).round(2)
    end
  end
end


def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart=apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  
  total = 0
  cart.each do |item,attributes|
    total += (cart[item][:price] * cart[item][:count])
  end
  
  if total > 100
    total *= 0.9
  end
  return total
end
