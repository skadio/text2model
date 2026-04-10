% Tabletop golf toy production planning (maximize profit)
% All data embedded as required.

include "globals.mzn";

set of int: T = 1..3;                 % 1=high-end, 2=mid-range, 3=low-end

array[T] of int: labor_req   = [17, 10,  2];
array[T] of int: insp_req    = [ 8,  4,  2];
array[T] of int: profit_unit = [300,200,100];
array[T] of int: demand_max  = [50, 80, 150];

int: labor_avail = 1000;
int: insp_avail  = 500;

array[T] of var 0..max(demand_max): x;  % units produced of each type

% Demand limits
constraint forall(t in T)(x[t] <= demand_max[t]);

% Resource constraints
constraint sum(t in T)(labor_req[t] * x[t]) <= labor_avail;
constraint sum(t in T)(insp_req[t]  * x[t]) <= insp_avail;

% Objective: maximize total profit
var int: total_profit = sum(t in T)(profit_unit[t] * x[t]);

solve maximize total_profit;

output [
  "Production plan (units):\n",
  "  High-end   = ", show(x[1]), "\n",
  "  Mid-range  = ", show(x[2]), "\n",
  "  Low-end    = ", show(x[3]), "\n\n",
  "Labor used      = ", show(sum(t in T)(labor_req[t] * x[t])), " / ", show(labor_avail), "\n",
  "Inspection used = ", show(sum(t in T)(insp_req[t] * x[t])), " / ", show(insp_avail), "\n\n",
  "Total profit = ", show(total_profit), " yuan\n"
];