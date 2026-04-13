% Chemical mixing optimization (all data embedded)

% Data
int: timeA = 30;          % seconds per unit of A
int: timeB = 45;          % seconds per unit of B
int: minA  = 300;         % at least 300 units of A
int: minTot = 1500;       % at least 1500 total units
int: maxTot = 1000000;    % safe upper bound to keep domains finite

% Decision variables
var minA..maxTot: A;      % units of chemical A
var 0..maxTot:  B;        % units of chemical B

% Constraints
constraint A + B >= minTot;
constraint 3 * A <= B;    % "at most a third as much A as B" => A <= B/3

% Objective: minimize total time
var 0..intmax: totalTime = timeA * A + timeB * B;
solve minimize totalTime;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Total units = ", show(A + B), "\n",
  "Total time (s) = ", show(totalTime), "\n"
];