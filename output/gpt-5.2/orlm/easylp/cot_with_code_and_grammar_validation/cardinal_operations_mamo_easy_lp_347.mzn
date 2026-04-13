int: total_investment = 10000000;

set of int: Projects = 1..4;

array[Projects] of int: min_invest = [2000000, 0, 1500000, 0];
array[Projects] of int: max_invest = [total_investment, 5000000, total_investment, 3000000];

array[Projects] of int: return_pct = [5, 7, 6, 8];

array[Projects] of var int: invest;
var int: total_return_dollars;

constraint forall(p in Projects) (invest[p] >= min_invest[p]);
constraint forall(p in Projects) (invest[p] <= max_invest[p]);

constraint sum(p in Projects)(invest[p]) = total_investment;

constraint total_return_dollars =
  sum(p in Projects)((invest[p] * return_pct[p]) div 100);

solve minimize total_return_dollars;

output [
  "invest_X=", show(invest[1]), "\n",
  "invest_Y=", show(invest[2]), "\n",
  "invest_Z=", show(invest[3]), "\n",
  "invest_W=", show(invest[4]), "\n",
  "min_total_return_dollars=", show(total_return_dollars), "\n"
];