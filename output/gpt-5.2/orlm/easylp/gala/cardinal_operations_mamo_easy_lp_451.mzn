% Fertilizer & Pesticide cost minimization (all data embedded)

% Decision variables (whole units)
var 0..100: fert;   % Fertilizer units
var 0..60: pest;    % Pesticide units

% Constraints
constraint fert + pest >= 50;          % at least 50 units combined
constraint 2 * fert + pest <= 120;     % environmental regulation
constraint fert >= pest + 10;          % fertilizer at least 10 more than pesticide

% Objective: minimize total cost
var int: total_cost = 2 * fert + 3 * pest;
solve minimize total_cost;

output [
  "Fertilizer = ", show(fert), "\n",
  "Pesticide = ", show(pest), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];