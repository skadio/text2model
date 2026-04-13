% Terracotta jar production planning (maximize profit)

% Data (embedded)
int: shape_avail = 3000;   % minutes/week
int: bake_avail  = 4000;   % minutes/week

int: shape_thin  = 50;
int: bake_thin   = 90;
int: profit_thin = 5;

int: shape_stubby  = 30;
int: bake_stubby   = 150;
int: profit_stubby = 9;

% Decision variables: number of jars (nonnegative integers)
var 0..(shape_avail div shape_thin): thin;
var 0..(shape_avail div shape_stubby): stubby;

% Resource constraints
constraint shape_thin * thin + shape_stubby * stubby <= shape_avail;
constraint bake_thin  * thin + bake_stubby  * stubby <= bake_avail;

% Objective
var int: total_profit = profit_thin * thin + profit_stubby * stubby;
solve maximize total_profit;

output [
  "thin = ", show(thin), "\n",
  "stubby = ", show(stubby), "\n",
  "total_profit = ", show(total_profit), "\n",
  "shaping_used = ", show(shape_thin * thin + shape_stubby * stubby), " / ", show(shape_avail), "\n",
  "baking_used = ", show(bake_thin * thin + bake_stubby * stubby), " / ", show(bake_avail), "\n"
];