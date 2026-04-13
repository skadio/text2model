% Parameters (with values embedded)
int: nProd = 2;
set of int: PROD = 1..nProd;

int: MEATIES = 1;
int: YUMMIES = 2;

array[PROD] of float: price = [2.80, 2.00];          % $/pack
array[PROD] of float: var_cost = [0.25, 0.20];       % $/pack

float: grain_cost = 0.20;                             % $/lb
float: meat_cost  = 0.50;                             % $/lb

array[PROD] of float: grain_lb = [2.0, 3.0];          % lb/pack
array[PROD] of float: meat_lb  = [3.0, 1.5];          % lb/pack

float: grain_avail = 400000.0;                        % lb/month
float: meat_avail  = 300000.0;                        % lb/month
int: meaties_capacity = 90000;                        % packs/month

% Variables
array[PROD] of var int: x;                            % packs produced

var float: profit;

% Constraints
constraint forall(p in PROD)(x[p] >= 0);

constraint sum(p in PROD)(grain_lb[p] * int2float(x[p])) <= grain_avail;
constraint sum(p in PROD)(meat_lb[p]  * int2float(x[p])) <= meat_avail;

constraint x[MEATIES] <= meaties_capacity;

% Objective
constraint profit =
  sum(p in PROD)(
    (price[p] - var_cost[p]) * int2float(x[p])
  )
  - grain_cost * sum(p in PROD)(grain_lb[p] * int2float(x[p]))
  - meat_cost  * sum(p in PROD)(meat_lb[p]  * int2float(x[p]));

solve maximize profit;

output [
  "Meaties packs = ", show(x[MEATIES]), "\n",
  "Yummies packs = ", show(x[YUMMIES]), "\n",
  "Profit = $", show(profit), "\n"
];