def consolidate_cart(cart)
consolidated = {}
cart.each do |items|
  items.each do |item_key,values|
    if consolidated[item_key].nil?
    consolidated[item_key] ||= values
    consolidated[item_key][:count]=1
    else
    consolidated[item_key][:count] +=1
    end
  end
end
return consolidated
end

def apply_coupons(cart, coupons)
applied_coupons ={}
if !coupons.empty?
coupons.each do |coupon|
  cart.each do |in_cart,values|
    if coupon[:item] == in_cart && coupon[:num] <= values[:count]
    applied_coupons[in_cart] ||= values
    values[:count] = values[:count] - coupon[:num]

    if applied_coupons[in_cart+" W/COUPON"].nil?
    applied_coupons[in_cart+" W/COUPON"] ||= {:price =>coupon[:cost], :clearance =>values[:clearance] }
    applied_coupons[in_cart+" W/COUPON"][:count]=1
    else
    applied_coupons[in_cart+" W/COUPON"][:count] +=1
    end

    else 
    applied_coupons[in_cart] ||= values
    end
  end
end
else 
  return cart
end
return applied_coupons
end

def apply_clearance(cart)
cleared = {}
cart.each do |item,values|
  if values[:clearance] == true
    cleared[item] ||= values
    cleared[item][:price] = (values[:price]*0.8).round(3)
  end
end
end

def checkout(cart, coupons)
cart = consolidate_cart(cart)
cart = apply_coupons(cart,coupons)
cart = apply_clearance(cart)
total = 0
cart.each do |item,values|
total += values[:price]*values[:count]
end
if total > 100
  total = total*0.9
end
return total
end
