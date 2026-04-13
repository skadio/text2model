% School budget allocation (integer linear programming in dollars)
% Minimize resource consumption: 0.3*T + 0.2*R + 0.4*B + 0.1*M
% Subject to bounds and total budget equality.

% -------------------- Embedded data --------------------
int: Budget = 100000;  % Total available budget in dollars

% Bounds (all in dollars)
int: T_min = 50000; int: T_max = 80000;   % Teacher salaries
int: R_min = 10000; int: R_max = 20000;   % Classroom rent
int: B_min =  5000; int: B_max = 10000;   % Textbooks
int: M_min =  5000; int: M_max =  7000;   % Misc

% -------------------- Decision variables --------------------
var T_min..T_max: T;   % teacher salaries
var R_min..R_max: R;   % rent
var B_min..B_max: B;   % textbooks
var M_min..M_max: M;   % miscellaneous

% -------------------- Constraints --------------------
constraint T + R + B + M = Budget;

% Scale objective by 10 to avoid decimals:
% 10*(0.3*T + 0.2*R + 0.4*B + 0.1*M) = 3*T + 2*R + 4*B + 1*M
var int: obj10 = 3*T + 2*R + 4*B + M;

solve minimize obj10;

% -------------------- Output --------------------
% Total resource consumption units = obj10 / 10.0
output [
  "T = ", show(T), "\n",
  "R = ", show(R), "\n",
  "B = ", show(B), "\n",
  "M = ", show(M), "\n",
  "MinTotalCostUnits = ", show(obj10 / 10.0), "\n"
];