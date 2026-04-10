int: min_value_23 = 50000;
int: max_value_32 = 100000;
int: cost_bond = 7;
int: cost_stock = 5;

var 0..max_value_32: bonds;
var 0..min_value_23: stocks;
var 0..(cost_bond * max_value_32 + cost_stock * min_value_23): total_cost;

constraint 2 * bonds + 3 * stocks >= min_value_23;
constraint 3 * bonds + 2 * stocks <= max_value_32;
constraint total_cost = cost_bond * bonds + cost_stock * stocks;

solve minimize total_cost;

output ["bonds=", show(bonds), " stocks=", show(stocks), " total_cost=", show(total_cost), "\n"];