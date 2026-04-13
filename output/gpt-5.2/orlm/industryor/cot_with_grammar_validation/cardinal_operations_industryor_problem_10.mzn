% Parameters
int: nProd = 2;
set of int: PROD = 1..nProd;

int: nProc = 3;
set of int: PROC = 1..nProc;

% Process indices: 1=Manufacturing, 2=Assembly, 3=Inspection
array[PROC, PROD] of int: time_per_unit = 
  array2d(PROC, PROD, [
    20, 0,   % Manufacturing hours per unit for (A,B)
     5, 7,   % Assembly hours per unit for (A,B)
     3, 6    % Inspection hours per unit for (A,B)
  ]);

array[PROC] of int: capacity = [120, 80, 40];
array[PROC] of int: cost_per_hour = [12, 8, 10];

array[PROD] of int: sell_price = [650, 725];

% Profit requirement and minimum production
int: min_profit = 3000;
int: min_A = 5;

% Upper bounds for production from capacities (simple safe bounds)
int: ub_A = min(capacity[1] div 20, min(capacity[2] div 5, capacity[3] div 3));
int: ub_B = min(capacity[2] div 7, capacity[3] div 6);

% Variables
array[PROD] of var 0..max(ub_A, ub_B): x;   % x[1]=Type A, x[2]=Type B
array[PROC] of var 0..max(capacity): used;
array[PROC] of var 0..max(capacity): idle;

var int: revenue;
var int: total_cost;
var int: profit;
var int: weighted_idle;

% Constraints
constraint x[1] <= ub_A;
constraint x[2] <= ub_B;

constraint x[1] >= min_A;

constraint forall(p in PROC) (
  used[p] = sum(i in PROD)(time_per_unit[p,i] * x[i])
);

constraint forall(p in PROC) (
  used[p] <= capacity[p]
);

constraint forall(p in PROC) (
  idle[p] = capacity[p] - used[p]
);

constraint revenue = sum(i in PROD)(sell_price[i] * x[i]);

constraint total_cost = sum(p in PROC)(cost_per_hour[p] * used[p]);

constraint profit = revenue - total_cost;

constraint profit >= min_profit;

constraint weighted_idle = sum(p in PROC)(cost_per_hour[p] * idle[p]);

% Objective
solve maximize profit;