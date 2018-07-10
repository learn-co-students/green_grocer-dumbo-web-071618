def consolidate_cart(cart)
  # code here
  arr = []
  hash = {}
  cart.each do |el|
    if !hash.key?(el.keys[0])
    hash[el.keys[0]] = {}
    el.each do |k , v|
      v.each do |k1, v1|
        hash[el.keys[0]][k1] = v1
        hash[el.keys[0]][:count] = 1
      end
    end
    else
      hash[el.keys[0]][:count] += 1
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    if cart.key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] -= coupon[:num]
      if cart.key?(coupon[:item] + " W/COUPON")
        cart[coupon[:item] + " W/COUPON"][:count] += 1
      else
        cart[coupon[:item] + " W/COUPON"] = {
          :price => coupon[:cost],
          :clearance => cart[coupon[:item]][:clearance],
          :count => 1
        }
      end
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |k, v|
    v[:price] = (v[:price] * 0.8).round(3) if v[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |k, v|
    total += v[:price] * v[:count]
  end
  total > 100 ? (0.9 * total) : total
end
