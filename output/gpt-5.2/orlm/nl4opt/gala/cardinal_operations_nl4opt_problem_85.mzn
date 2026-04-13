% Maple Oil blending/production LP
% Maximize revenue subject to compound A and B availability.

% Data (embedded as requested)
int: n = 3;
set of int: OILS = 1..n;

array[OILS] of int: revenue = [550, 750, 950];   % light, non-sticky, heavy
array[OILS] of int: reqA    = [3,   6,   9];
array[OILS] of int: reqB    = [3,   2,   3];

int: availA = 250;
int: availB = 150;

% Decision variables: allow full or partial tanks -> continuous nonnegative
array[OILS] of var float: x;   % tanks processed of each oil type

constraint forall(i in OILS)(x[i] >= 0.0);

% Resource constraints
constraint sum(i in OILS)(reqA[i] * x[i]) <= availA;
constraint sum(i in OILS)(reqB[i] * x[i]) <= availB;

% Objective
var float: totalRevenue = sum(i in OILS)(revenue[i] * x[i]);

solve maximize totalRevenue;

output [
  "Tanks (light, non-sticky, heavy) = ", show(x), "\n",
  "Total revenue = ", show(totalRevenue), "\n"
];