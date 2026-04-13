% Parameters
int: N = 3;                      % number of component types
int: SMax = 5;                   % maximum number of spares allowed per component
set of int: C = 1..N;
set of int: S = 0..SMax;

int: budget_limit = 150;
int: weight_limit = 20;

array[C] of int: unit_price = [20, 30, 40];
array[C] of int: unit_weight = [2, 4, 6];

% Reliability table r[c,s] for component c with s spares installed
% To keep the objective linear/integer, use scaled reliabilities (x100):
% 0.50 -> 50, 0.95 -> 95, etc.
array[C, S] of int: rel100 = array2d(C, S,
[
  50, 60, 70, 80, 90, 100,   % component 1, s=0..5
  60, 75, 95, 100, 100, 100, % component 2, s=0..5
  70, 90, 100, 100, 100, 100 % component 3, s=0..5
]);

% Variables
array[C] of var S: spares;                % number of spares chosen for each component type
array[C] of var 0..100: comp_rel100;      % resulting reliability (x100) for each component
var 0..1000000: sys_rel1000000;           % system reliability (x1,000,000)

% Constraints
constraint
  forall(c in C) (
    comp_rel100[c] = rel100[c, spares[c]]
  );

constraint
  sum(c in C)(unit_price[c] * spares[c]) <= budget_limit;

constraint
  sum(c in C)(unit_weight[c] * spares[c]) <= weight_limit;

% System reliability = product of component reliabilities
% With scaling: (r1/100)*(r2/100)*(r3/100)
% Maximize integer sys_rel1000000 = r1*r2*r3 (since (r1*r2*r3)/1e6 is the true reliability)
constraint
  sys_rel1000000 = comp_rel100[1] * comp_rel100[2] * comp_rel100[3];

% Objective
solve maximize sys_rel1000000;