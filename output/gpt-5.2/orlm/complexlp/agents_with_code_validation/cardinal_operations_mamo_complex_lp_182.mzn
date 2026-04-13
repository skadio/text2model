% Fruit salad production with near-complete resource usage (±5 units)
% Data embedded as constants (no .dzn needed)

% Resource availability (units of fruit in stock)
int: stock_mango = 25;
int: stock_pineapple = 10;
int: stock_strawberry = 120;

% Scale factor to avoid fractions (LCM of denominators 4 and 8 is 8)
int: L = 8;

% Fruit consumption per unit of salad (scaled by L)
% A uses (1/4, 1/8, 3) -> (2, 1, 24)
% B uses (1/2, 1/4, 1) -> (4, 2, 8)
int: a_mango = 2;
int: a_pineapple = 1;
int: a_strawberry = 24;

int: b_mango = 4;
int: b_pineapple = 2;
int: b_strawberry = 8;

% Profits per unit
int: profit_A = 10;
int: profit_B = 20;

% Allowed deviation from fully using each resource (<= 5 units left or 5 extra used)
int: deviation_limit = 5;

% Scaled resource stocks
int: stock_mango_s = L * stock_mango;
int: stock_pineapple_s = L * stock_pineapple;
int: stock_strawberry_s = L * stock_strawberry;

% Scaled deviation limits
int: deviation_s = L * deviation_limit;

% Upper bounds for production based on individual resources (using max over an array)
int: ubA = max([
  stock_mango_s div a_mango,
  stock_pineapple_s div a_pineapple,
  stock_strawberry_s div a_strawberry
]);

int: ubB = max([
  stock_mango_s div b_mango,
  stock_pineapple_s div b_pineapple,
  stock_strawberry_s div b_strawberry
]);

% Decision variables (complete fruit salads)
var 0..ubA: xA;
var 0..ubB: xB;

% Resource usage in scaled units
var 0..(a_mango * ubA + b_mango * ubB): used_mango_s;
var 0..(a_pineapple * ubA + b_pineapple * ubB): used_pineapple_s;
var 0..(a_strawberry * ubA + b_strawberry * ubB): used_strawberry_s;

% Total profit
var 0..(profit_A * ubA + profit_B * ubB): total_profit;

% Link production decisions to scaled resource usage
constraint used_mango_s      = a_mango      * xA + b_mango      * xB;
constraint used_pineapple_s  = a_pineapple  * xA + b_pineapple  * xB;
constraint used_strawberry_s = a_strawberry * xA + b_strawberry * xB;

% Each resource must be within ±5 (unscaled) units of full usage
constraint abs(used_mango_s      - stock_mango_s)      <= deviation_s;
constraint abs(used_pineapple_s  - stock_pineapple_s)  <= deviation_s;
constraint abs(used_strawberry_s - stock_strawberry_s) <= deviation_s;

% Profit definition
constraint total_profit = profit_A * xA + profit_B * xB;

% Objective type requested: satisfaction
solve satisfy;

output [
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n",
  "total_profit = ", show(total_profit), "\n",
  "used_mango = ", show(used_mango_s), " (scaled by ", show(L), ")\n",
  "used_pineapple = ", show(used_pineapple_s), " (scaled by ", show(L), ")\n",
  "used_strawberry = ", show(used_strawberry_s), " (scaled by ", show(L), ")\n"
];