% Forest Paper production (all data embedded)

% Index sets
int: n_products = 2;
set of int: PRODUCTS = 1..n_products;
int: GRAPH = 1;
int: MUSIC = 2;

int: n_machines = 2;
set of int: MACHINES = 1..n_machines;
int: PRINT = 1;
int: SCAN  = 2;

% Data
int: max_minutes_per_machine = 350;

array[MACHINES, PRODUCTS] of int: minutes_per_ream_x2 =
  array2d(MACHINES, PRODUCTS,
    [ 6, 3,    % PRINT: graph, music  (3.0, 1.5) * 2
      11, 6 ]  % SCAN : graph, music  (5.5, 3.0) * 2
  );

array[PRODUCTS] of int: profit_per_ream_x2 = [8, 5]; % (4.0, 2.5) * 2

% Variables
array[PRODUCTS] of var 0..1000000: reams;  % nonnegative integer
var int: total_profit_x2;

% Constraints (scale all times/profits by 2 to avoid float linear issues in Gecode)
constraint
  sum(p in PRODUCTS)(minutes_per_ream_x2[PRINT, p] * reams[p]) <= 2 * max_minutes_per_machine;

constraint
  sum(p in PRODUCTS)(minutes_per_ream_x2[SCAN, p] * reams[p]) <= 2 * max_minutes_per_machine;

constraint
  total_profit_x2 = sum(p in PRODUCTS)(profit_per_ream_x2[p] * reams[p]);

% Objective
solve maximize total_profit_x2;

% Output (profit in dollars)
output [
  "Graph reams = ", show(reams[GRAPH]), "\n",
  "Music reams = ", show(reams[MUSIC]), "\n",
  "Profit = $", show(total_profit_x2 div 2),
  if total_profit_x2 mod 2 = 0 then ".0" else ".5" endif, "\n"
];