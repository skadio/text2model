% Real estate investment planning (all data embedded)

% Decision variables: units invested in each property type (integers)
var int: X; % residential
var int: Y; % commercial
var int: Z; % industrial

% Bounds (minimum viable investment and maximum allowed)
constraint 100 <= X /\ X <= 300;
constraint 50  <= Y /\ Y <= 200;
constraint 30  <= Z /\ Z <= 150;

% Total budget constraint
constraint X + Y + Z <= 500;

% Total cost/return (as given per unit)
% (Despite the wording "minimize cost", the only provided unit figures are returns; we treat them as per-unit cost.)
var int: total_cost = 100 * X + 200 * Y + 150 * Z;

solve minimize total_cost;

output [
  "X (residential units) = ", show(X), "\n",
  "Y (commercial units)  = ", show(Y), "\n",
  "Z (industrial units)  = ", show(Z), "\n",
  "Total cost ($)        = ", show(total_cost), "\n"
];