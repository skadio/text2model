% Energy project allocation - minimize total cost
% All data embedded as per problem description.

var 0..4000: X;         % Project X upper bound 4000
var 0..3000: Y;         % Project Y upper bound 3000
var 500..100000: Z;     % Project Z minimum 500 (large upper bound to avoid restricting)
var 200..100000: W;     % Project W minimum 200 (large upper bound to avoid restricting)

% Budget constraints
constraint X + Y <= 5000;
constraint Z + W <= 2000;

% Net investment difference constraints
constraint X - Z >= 1000;
constraint Y - W >= 1500;

% Objective: minimize total cost (dollars per unit)
var int: total_cost = 20 * X + 30 * Y + 50 * Z + 10 * W;
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "W=", show(W), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];