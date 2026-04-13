% Shipping company optimization (all data embedded)

int: weight_req = 2000;      % minimum total weight (tons)
int: volume_cap = 3000;      % maximum total volume (cubic meters)
int: diff_req = 500;         % ShipA must be at least 500 more than ShipB

% Coefficients
int: wA = 2; int: wB = 3; int: wC = 4;   % weight contribution per unit
int: vA = 3; int: vB = 2; int: vC = 1;   % volume usage per unit
int: cA = 7; int: cB = 6; int: cC = 5;   % cost per unit ($)

% Decision variables (integer numbers of ships/units)
var 0..3000: A;
var 0..3000: B;
var 0..3000: C;

constraint wA*A + wB*B + wC*C >= weight_req;
constraint vA*A + vB*B + vC*C <= volume_cap;
constraint A >= B + diff_req;

var int: total_cost = cA*A + cB*B + cC*C;

solve minimize total_cost;

output [
  "ShipA=", show(A), "\n",
  "ShipB=", show(B), "\n",
  "ShipC=", show(C), "\n",
  "MinimumTotalCostDollars=", show(total_cost), "\n"
];