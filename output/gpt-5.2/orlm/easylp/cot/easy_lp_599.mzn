% Parameters (with values embedded)
int: n = 4;
set of int: I = 1..n;

% Costs in units of $1000
array[I] of int: cost = [5, 6, 7, 8]; % stocks, bonds, mutual funds, gold

% Variable bounds in $ (whole dollars, integer)
int: stocks_lb = 1000;
int: stocks_ub = 5000;

int: bonds_lb  = 500;
int: bonds_ub  = 3000;

int: mutual_lb = 2000;
int: mutual_ub = 10000; % implicit safe upper bound

int: gold_lb   = 1500;
int: gold_ub   = 10000; % implicit safe upper bound

int: total_ub  = 10000;

% Additional constraints constants in $
int: diff_sb_ub = 5000;
int: mutual_minus_gold_lb = 3000;
int: stocks_min_extra = 2000;
int: bonds_max_extra = 4000;

% Variables
var stocks_lb..stocks_ub: stocks;
var bonds_lb..bonds_ub: bonds;
var mutual_lb..mutual_ub: mutualFunds;
var gold_lb..gold_ub: gold;

% Total cost in units of $1000 * $ (will be divided by 1000 for reporting)
var 0..(max(cost) * total_ub): totalCostK;

% Constraints
constraint abs(stocks - bonds) <= diff_sb_ub;
constraint mutualFunds - gold >= mutual_minus_gold_lb;
constraint stocks + bonds + mutualFunds + gold <= total_ub;

constraint stocks >= stocks_min_extra;
constraint bonds <= bonds_max_extra;

% Objective (minimize total cost; costs are per $1000, so use allocation/1000)
% Since allocations are in whole dollars, compute exact cost in $ by scaling:
% totalCostK represents cost in "($1000 cost units) * $", so divide by 1000 to get $1000 units.
constraint totalCostK = cost[1]*stocks + cost[2]*bonds + cost[3]*mutualFunds + cost[4]*gold;

solve minimize totalCostK;

% Report minimum total cost rounded to nearest thousand dollars:
output [
  "stocks=$", show(stocks), "\n",
  "bonds=$", show(bonds), "\n",
  "mutualFunds=$", show(mutualFunds), "\n",
  "gold=$", show(gold), "\n",
  "totalCost=$", show(totalCostK div 1000), "000 (rounded to nearest $1000)\n"
];