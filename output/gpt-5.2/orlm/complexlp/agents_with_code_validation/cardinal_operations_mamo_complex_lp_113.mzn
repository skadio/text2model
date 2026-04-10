% Max flow from source (0) to sink (5) in a directed capacitated network

int: N = 6;
set of int: CITIES = 0..N-1;
int: source = 0;
int: sink = 5;

array[CITIES, CITIES] of int: cap =
[
|  0, 17, 14, 13, 11,  3 |
|  1,  0, 18, 14, 12, 16 |
|  5,  1,  0,  7,  2,  5 |
| 10, 13, 19,  0,  4, 16 |
|  3,  0, 13,  0,  0, 14 |
| 15, 16,  4,  1, 16,  0 |
];

% Use a safe upper bound for variable domains (sum of all capacities)
int: UB = sum(i in CITIES, j in CITIES)(cap[i,j]);

array[CITIES, CITIES] of var 0..UB: flow;
var 0..UB: total_flow;

% Capacity constraints and prohibit self-loops
constraint forall(i in CITIES, j in CITIES)(
  flow[i,j] <= cap[i,j]
);
constraint forall(i in CITIES)(
  flow[i,i] = 0
);

% Flow conservation at intermediate nodes
constraint forall(k in CITIES where k != source /\ k != sink)(
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

% Define total_flow as net outflow from source and net inflow to sink
constraint total_flow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);
constraint total_flow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

solve maximize total_flow;

output [
  "max_flow = ", show(total_flow), "\n"
];