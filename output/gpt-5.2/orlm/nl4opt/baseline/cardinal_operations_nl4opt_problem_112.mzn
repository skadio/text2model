% Bread mixer chemicals optimization
% Minimize total time (in seconds) given effectiveness times and safety constraints.

int: tA = 30;   % seconds per unit of chemical A
int: tB = 45;   % seconds per unit of chemical B

int: minA = 300;        % at least 300 units of A
int: minTotal = 1500;   % at least 1500 total units

% Decision variables (units to add)
var 0..100000: A;
var 0..100000: B;

% Constraints
constraint A >= minA;
constraint A + B >= minTotal;

% Safety: at most a third as much A as B  => A <= B/3  => 3A <= B
constraint 3 * A <= B;

% Objective: minimize total time
var int: total_time = tA * A + tB * B;
solve minimize total_time;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Total units = ", show(A + B), "\n",
  "Total time (seconds) = ", show(total_time), "\n"
];