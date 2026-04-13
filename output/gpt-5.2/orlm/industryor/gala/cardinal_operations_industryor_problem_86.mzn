% Truck rental minimization (all data embedded)

% Data
int: req_ref  = 3000;   % m^3 refrigerated cargo required
int: req_non  = 4000;   % m^3 non-refrigerated cargo required

% Type A capacities (m^3)
int: A_ref = 20;
int: A_non = 40;

% Type B: same total capacity as Type A, split equally between ref/non
int: total_cap = A_ref + A_non;   % 60
int: B_ref = total_cap div 2;     % 30
int: B_non = total_cap div 2;     % 30

% Costs per km
int: costA = 30;
int: costB = 40;

% Upper bounds (safe, derived from requirements)
int: maxA = max( (req_ref + A_ref - 1) div A_ref, (req_non + A_non - 1) div A_non );
int: maxB = max( (req_ref + B_ref - 1) div B_ref, (req_non + B_non - 1) div B_non );

% Decision variables: number of trucks
var 0..maxA: nA;
var 0..maxB: nB;

% Capacity constraints
constraint A_ref * nA + B_ref * nB >= req_ref;
constraint A_non * nA + B_non * nB >= req_non;

% Objective: minimize total cost per km
var int: totalCost = costA * nA + costB * nB;

solve minimize totalCost;

output [
  "Type A trucks = ", show(nA), "\n",
  "Type B trucks = ", show(nB), "\n",
  "Total cost per km = ", show(totalCost), "\n",
  "Provided refrigerated = ", show(A_ref*nA + B_ref*nB), " (need ", show(req_ref), ")\n",
  "Provided non-refrigerated = ", show(A_non*nA + B_non*nB), " (need ", show(req_non), ")\n"
];