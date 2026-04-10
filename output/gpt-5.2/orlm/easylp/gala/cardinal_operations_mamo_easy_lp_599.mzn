include "globals.mzn";

/*
  Units:
  - Decision variables are in $1000 units (integer).
  - Costs are per $1000 invested.
  - Objective minimizes total cost.
*/

% Costs (per $1000)
int: c_stocks = 5;
int: c_bonds  = 6;
int: c_mutual = 7;
int: c_gold   = 8;

% Decision variables ($1000 units)
var 1..5: stocks;          % $1000..$5000
var 1..3: bonds;           % $500..$3000 (whole $1000 units approximation)
var 2..10: mutual_funds;   % at least $2000
var 2..10: gold;           % at least $1500 -> in $1000 units => >= 2

% Constraints
constraint abs(stocks - bonds) <= 5;                 % <= $5000
constraint mutual_funds >= gold + 3;                 % at least $3000 more
constraint stocks + bonds + mutual_funds + gold <= 10; % total <= $10000
constraint stocks >= 2;                               % min $2000 in stocks
constraint bonds <= 4;                                % max $4000 in bonds (redundant with bonds<=3)

% Objective: minimize total cost
var int: total_cost = c_stocks*stocks + c_bonds*bonds + c_mutual*mutual_funds + c_gold*gold;

solve minimize total_cost;

% Output: minimum total cost, rounded to nearest thousand dollars
output [
  "stocks($1000)= ", show(stocks), "\n",
  "bonds($1000)= ", show(bonds), "\n",
  "mutual_funds($1000)= ", show(mutual_funds), "\n",
  "gold($1000)= ", show(gold), "\n",
  "min_total_cost($1000)= ", show(total_cost), "\n",
  "min_total_cost($)= ", show(total_cost * 1000), "\n"
];