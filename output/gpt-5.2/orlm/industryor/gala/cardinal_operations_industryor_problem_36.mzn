% Microcomputer production planning (Models A and B)
% Maximize profit subject to process capacities and minimum production requirements.
% Data embedded directly as requested.

include "globals.mzn";

%---------------------------
% Data
%---------------------------
set of int: MODELS = 1..2;
int: A = 1;
int: B = 2;

array[MODELS] of int: profit = [300, 450];

% Processing times (hours per unit) for each process
int: procI_cap  = 150;
int: procII_cap = 70;

array[MODELS] of int: procI_time  = [4, 6];
array[MODELS] of int: procII_time = [3, 2];

% Minimum production requirements
array[MODELS] of int: min_prod = [10, 15];

% Profit goal (must not be less than)
int: min_profit = 10000;

%---------------------------
% Decision variables
%---------------------------
array[MODELS] of var 0..1000: x;  % x[A], x[B] units produced (upper bound is safely large)

% Derived quantities
var 0..1000000: total_profit =
  sum(m in MODELS)(profit[m] * x[m]);

var 0..1000000: time_I =
  sum(m in MODELS)(procI_time[m] * x[m]);

var 0..1000000: time_II =
  sum(m in MODELS)(procII_time[m] * x[m]);

% If overtime is allowed for process II, model it explicitly
var 0..1000000: overtime_II;
constraint overtime_II = max(0, time_II - procII_cap);

%---------------------------
% Constraints
%---------------------------

% p2: contractual minimum production
constraint forall(m in MODELS)( x[m] >= min_prod[m] );

% Process I: should be exactly 150 hours (fully utilized)
constraint time_I = procI_cap;

% Process II: "fully utilized, with potential overtime if necessary"
% Interpreted as: at least fully utilized (>= 70); overtime allowed by exceeding 70.
constraint time_II >= procII_cap;

% p1: profit goal
constraint total_profit >= min_profit;

%---------------------------
% Objective: maximize total profit
%---------------------------
solve maximize total_profit;

%---------------------------
% Output
%---------------------------
output [
  "Units A = ", show(x[A]), "\n",
  "Units B = ", show(x[B]), "\n",
  "Time I  = ", show(time_I), " (cap ", show(procI_cap), ")\n",
  "Time II = ", show(time_II), " (cap ", show(procII_cap), ")\n",
  "Overtime II = ", show(overtime_II), "\n",
  "Total profit = ", show(total_profit), "\n"
];