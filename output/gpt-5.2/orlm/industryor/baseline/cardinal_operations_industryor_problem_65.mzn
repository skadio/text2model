% Tabletop golf toy production planning (maximize profit)

int: n = 3;
set of int: P = 1..n;

% 1=high-end, 2=mid-range, 3=low-end
array[P] of int: labor_per_unit = [17, 10, 2];
array[P] of int: insp_per_unit  = [8,  4,  2];
array[P] of int: profit_per_unit = [300, 200, 100];

int: labor_available = 1000;
int: insp_available  = 500;

array[P] of int: demand_max = [50, 80, 150];

array[P] of var 0..max(demand_max): x;

constraint forall(i in P)(x[i] <= demand_max[i]);

constraint sum(i in P)(labor_per_unit[i] * x[i]) <= labor_available;
constraint sum(i in P)(insp_per_unit[i]  * x[i]) <= insp_available;

var int: total_profit = sum(i in P)(profit_per_unit[i] * x[i]);

solve maximize total_profit;

output [
  "High-end units: ", show(x[1]), "\n",
  "Mid-range units: ", show(x[2]), "\n",
  "Low-end units: ", show(x[3]), "\n",
  "Total profit: ", show(total_profit), "\n",
  "Labor used: ", show(sum(i in P)(labor_per_unit[i] * x[i])), " / ", show(labor_available), "\n",
  "Inspection used: ", show(sum(i in P)(insp_per_unit[i] * x[i])), " / ", show(insp_available), "\n"
];