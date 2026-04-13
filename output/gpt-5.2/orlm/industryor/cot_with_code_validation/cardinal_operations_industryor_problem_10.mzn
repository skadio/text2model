% Parameters
int: nProducts = 2;
int: nProc = 3;

set of int: P = 1..nProducts;
set of int: R = 1..nProc;

array[P,R] of int: time = array2d(P, R,
[
  20, 5, 3,   % Type A: Manufacturing, Assembly, Inspection
  0,  7, 6    % Type B: Manufacturing, Assembly, Inspection
]);

array[R] of int: cap = [120, 80, 40];      % weekly capacities
array[R] of int: cost = [12, 8, 10];       % yuan/hour for each process
array[P] of int: price = [650, 725];       % yuan/unit selling prices

int: min_profit = 3000;
int: min_A = 5;

% Variables
array[P] of var 0..1000: x;                % production quantities (upper bound set safely large)
array[R] of var 0..1000: used;             % used hours per process
array[R] of var 0..1000: idle;             % idle hours per process

var int: revenue;
var int: proc_cost_total;
var int: profit;

% Constraints
constraint forall(r in R)(
  used[r] = sum(p in P)(time[p,r] * x[p])
);

constraint forall(r in R)(
  used[r] <= cap[r]           % no overtime
);

constraint forall(r in R)(
  idle[r] = cap[r] - used[r]
);

constraint x[1] >= min_A;

constraint revenue = sum(p in P)(price[p] * x[p]);

constraint proc_cost_total = sum(r in R)(cost[r] * used[r]);

constraint profit = revenue - proc_cost_total;

constraint profit >= min_profit;

% Objective
solve maximize profit;