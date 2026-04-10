int: max_total_investment = 1000;

int: bond_cost = 10;
int: stock_cost = 20;

var 0..max_total_investment: bonds;
var 0..max_total_investment: stocks;

constraint bonds + stocks <= max_total_investment;
constraint bonds >= stocks + 200;

var int: total_cost = bond_cost * bonds + stock_cost * stocks;

solve minimize total_cost;

output [
  "bonds=", show(bonds), "\n",
  "stocks=", show(stocks), "\n",
  "min_total_cost=", show(total_cost), "\n"
];