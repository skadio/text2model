% Microcomputer production planning (Models A and B)
% Data embedded from Table 3.1 and goal statements.

int: nModels = 2;
set of int: M = 1..nModels;
int: A = 1;
int: B = 2;

% Processing times (hours/unit): rows = processes {I, II}, cols = models {A,B}
int: nProc = 2;
set of int: P = 1..nProc;
int: I = 1;
int: II = 2;

array[P, M] of int: time = array2d(P, M, [
  4, 6,   % Process I: A, B
  3, 2    % Process II: A, B
]);

% Weekly capacity (hours) for each process
array[P] of int: cap = [150, 70];

% Profit ($/unit)
array[M] of int: profit = [300, 450];

% Goal/requirements data
int: minProfit = 10000;
array[M] of int: minUnits = [10, 15];

% Decision variables: integer units produced
array[M] of var 0..10000: x;

% Process time used (hours)
array[P] of var 0..100000: used;

constraint used[I]  = sum(m in M)(time[I, m]  * x[m]);
constraint used[II] = sum(m in M)(time[II, m] * x[m]);

% Hard contractual minimum production (p2)
constraint x[A] >= minUnits[A];
constraint x[B] >= minUnits[B];

% Capacity constraints (hard limits given in table)
constraint used[I]  <= cap[I];
constraint used[II] <= cap[II];

% Minimum weekly profit requirement (p1)
constraint sum(m in M)(profit[m] * x[m]) >= minProfit;

% Objective: maximize total profit
solve maximize sum(m in M)(profit[m] * x[m]);

output [
  "xA = ", show(x[A]), "\n",
  "xB = ", show(x[B]), "\n",
  "Profit = ", show(sum(m in M)(profit[m] * x[m])), "\n",
  "Process I used = ", show(used[I]), " / ", show(cap[I]), "\n",
  "Process II used = ", show(used[II]), " / ", show(cap[II]), "\n"
];