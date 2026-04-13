int: ref_demand = 3000;
int: nonref_demand = 4000;

int: A_ref_cap = 20;
int: A_nonref_cap = 40;

% Type B: same total as Type A (60), equal split => 30 and 30
int: B_total_cap = A_ref_cap + A_nonref_cap;
int: B_ref_cap = B_total_cap div 2;
int: B_nonref_cap = B_total_cap div 2;

int: cost_A = 30;
int: cost_B = 40;

% Upper bounds sufficient for feasibility
int: maxA = (ref_demand div A_ref_cap) + 1;
int: maxB = (ref_demand div B_ref_cap) + (nonref_demand div B_nonref_cap) + 2;

var 0..maxA: nA;
var 0..maxB: nB;

constraint A_ref_cap * nA + B_ref_cap * nB >= ref_demand;
constraint A_nonref_cap * nA + B_nonref_cap * nB >= nonref_demand;

var int: total_cost = cost_A * nA + cost_B * nB;
solve minimize total_cost;

output [
  "Type A trucks: ", show(nA), "\n",
  "Type B trucks: ", show(nB), "\n",
  "Total cost per km (£): ", show(total_cost), "\n"
];