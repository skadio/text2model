% Parameters
int: nCities = 7;                              % Number of cities (0..6)
set of int: CITIES = 0..nCities-1;             % City indices
int: source = 0;                               % Source city (distribution hub)
int: sink = 6;                                 % Sink city (destination)

array[CITIES, CITIES] of int: cap =            % Capacity matrix (thousands of kg/day); 0 => no arc
[
|  0, 20, 19, 18,  0, 11,  2
| 18,  0, 15, 10,  0,  9,  0
| 18,  4,  0, 11, 15,  0, 13
| 17,  3, 15,  0,  2,  4,  4
|  2, 11, 17, 17,  0,  2, 17
| 12,  4, 16, 13,  5,  0,  3
|  7,  9, 17, 18, 16,  8,  0
];

% Variables
array[CITIES, CITIES] of var 0..20: flow;      % Flow on each directed arc (bounded by max capacity 20)
var 0..1000: maxFlow;                          % Total flow from source to sink (objective variable)

% Constraints

%--- Capacity / arc existence constraints: no flow on non-arcs, and respect capacities on arcs
constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

%--- Flow conservation at intermediate cities (all except source and sink)
%    Total inflow equals total outflow for each transshipment node.
constraint
  forall(v in CITIES where v != source /\ v != sink) (
    sum(i in CITIES)(flow[i,v]) = sum(j in CITIES)(flow[v,j])
  );

%--- Define maxFlow as net outflow from the source
constraint
  maxFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

%--- Enforce equal net inflow at sink (consistency with source definition)
constraint
  maxFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

% Objective
solve maximize maxFlow;