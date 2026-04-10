% Parameters (with values embedded)
int: nProd = 2;
set of int: P = 1..nProd;

% Process indices: 1=Manufacturing, 2=Assembly, 3=Inspection
int: nProc = 3;
set of int: R = 1..nProc;

array[P] of string: prodName = ["A","B"];

% Time requirements (hours per unit): time[p,r]
array[P,R] of int: time = array2d(P,R,
  [ 20, 5, 3,   % Type A
     0, 7, 6 ]  % Type B
);

% Weekly capacities (hours)
array[R] of int: cap = [120, 80, 40];

% Process costs (Yuan per hour) - also used as idle-time weights
array[R] of int: cost = [12, 8, 10];

% Selling prices (Yuan per unit)
array[P] of int: price = [650, 725];

% Profit requirement and minimum production requirement
int: minProfit = 3000;
int: minA = 5;

% Compute unit variable cost from process costs and time requirements
array[P] of int: unitCost = [
  sum(r in R)(time[1,r] * cost[r]),
  sum(r in R)(time[2,r] * cost[r])
];

% Variables
var 0..1000: x1; % weekly units of Type A
var 0..1000: x2; % weekly units of Type B
array[P] of var 0..1000: x = [x1, x2];

% Derived totals
array[R] of var 0..100000: used;   % hours used per process
array[R] of var 0..100000: idle;   % idle hours per process (no overtime)
var -1000000..1000000: profit;

% Constraints
constraint
  forall(r in R)(
    used[r] = sum(p in P)(time[p,r] * x[p])
  );

constraint
  forall(r in R)(
    used[r] <= cap[r]   % no overtime
  );

constraint
  forall(r in R)(
    idle[r] = cap[r] - used[r]
  );

constraint
  x1 >= minA;  % at least 5 units of Type A

constraint
  profit = sum(p in P)(price[p] * x[p]) - sum(p in P)(unitCost[p] * x[p]);

constraint
  profit >= minProfit; % profit at least 3000

% Objective
% Maximize weekly profit (primary). Idle minimization is a goal; profit-max solution is returned.
solve maximize profit;

output [
  "x1 (Type A) = ", show(x1), "\n",
  "x2 (Type B) = ", show(x2), "\n",
  "Profit = ", show(profit), " Yuan\n",
  "Used hours (Mfg,Asm,Insp) = ", show(used), "\n",
  "Idle hours (Mfg,Asm,Insp) = ", show(idle), "\n",
  "Weighted idle cost = ",
    show(sum(r in R)(cost[r] * idle[r])), " Yuan-equivalent\n"
];