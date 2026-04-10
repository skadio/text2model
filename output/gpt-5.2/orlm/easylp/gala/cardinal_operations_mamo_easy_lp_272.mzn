% Sports tournament team allocation (all data embedded)

include "globals.mzn";

% Decision variables: number of players assigned to each team
var 0..50: x;  % team X
var 0..50: y;  % team Y
var 0..50: z;  % team Z

% Constraints
constraint x + y + z <= 50;     % total player limit
constraint y + z >= 30;         % balance requirement
constraint x + z <= 40;         % balance requirement

% Objective: minimize total performance score
var 0..1000: total_score = 3*x + 4*y + 2*z;

solve minimize total_score;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_performance_score=", show(total_score), "\n"
];