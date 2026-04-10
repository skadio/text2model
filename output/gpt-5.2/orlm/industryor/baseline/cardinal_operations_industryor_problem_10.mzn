% Small motorcycle production planning (embedded data)
% Maximize weekly profit, with requirements:
% p1: profit >= 3000
% p2: xA >= 5
% p3: minimize weighted idle time (weights = process hourly costs), no overtime

int: nProd = 2;
int: nProc = 3;

set of int: PROD = 1..nProd;
set of int: PROC = 1..nProc;

% Products: 1=Type A, 2=Type B
% Processes: 1=Manufacturing, 2=Assembly, 3=Inspection

array[PROC, PROD] of int: time_per_unit = array2d(PROC, PROD,
[
  20, 0,   % Manufacturing hours per unit for A,B
   5, 7,   % Assembly
   3, 6    % Inspection
]);

array[PROC] of int: capacity = [120, 80, 40];    % max weekly hours
array[PROC] of int: cost_per_hour = [12, 8, 10]; % Yuan/hour

array[PROD] of int: sell_price = [650, 725];

% Decision variables: weekly production quantities
var 0..100000: xA;
var 0..100000: xB;

array[PROD] of var int: x = [xA, xB];

% Used hours per process
array[PROC] of var int: used;
constraint forall(p in PROC)(
  used[p] = sum(j in PROD)(time_per_unit[p,j] * x[j])
);

% Capacity (no overtime)
constraint forall(p in PROC)( used[p] <= capacity[p] );

% Profit = revenue - process costs
var int: revenue = sum(j in PROD)(sell_price[j] * x[j]);
var int: proc_cost = sum(p in PROC)(cost_per_hour[p] * used[p]);
var int: profit = revenue - proc_cost;

% Requirements
constraint profit >= 3000;  % p1
constraint xA >= 5;         % p2

% Idle time and weighted idle objective component (p3)
array[PROC] of var int: idle;
constraint forall(p in PROC)( idle[p] = capacity[p] - used[p] );

var int: weighted_idle = sum(p in PROC)(cost_per_hour[p] * idle[p]);

% Lexicographic goal programming:
% 1) maximize profit
% 2) among max-profit plans, minimize weighted idle time
solve
  maximize profit * 1000000 - weighted_idle;

output [
  "xA(Type A) = ", show(xA), "\n",
  "xB(Type B) = ", show(xB), "\n",
  "Used hours (Mfg,Asm,Insp) = ", show([used[p] | p in PROC]), "\n",
  "Idle hours (Mfg,Asm,Insp) = ", show([idle[p] | p in PROC]), "\n",
  "Revenue = ", show(revenue), "\n",
  "ProcessCost = ", show(proc_cost), "\n",
  "Profit = ", show(profit), "\n",
  "WeightedIdle = ", show(weighted_idle), "\n"
];