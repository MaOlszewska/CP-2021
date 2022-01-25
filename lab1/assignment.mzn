% Parameters
int: money_limit;
var int: total_yumyum;
var int: total_price;
set of int: menu_items = index_set(menu_prices); 
array[int] of int: menu_prices;
array[menu_items] of string: menu_names;
array[menu_items] of int: yumyum_factors; 
array[menu_items] of var int: available;
array[menu_items] of var int: order;


constraint forall([order[i] >= 0 | i in menu_items]);
constraint sum([order[i] * menu_prices[i] | i in menu_items]) <= money_limit;
constraint forall([order[i] <= available[i] | i in menu_items]);
constraint assert(forall([menu_prices[i] >=0 | i in menu_items]), "negative price");

total_yumyum = sum([order[i] * yumyum_factors[i] | i in menu_items]);
total_price = sum([menu_prices[i] * order[i] | i in menu_items]);

solve maximize total_yumyum; 


output ["\(menu_names[i]): \(order[i])\n" | i in menu_items] ++ 
       ["- total price:\t\(total_price)/\(money_limit)\n"] ++
       ["- total yumyum:\t\(total_yumyum)"];