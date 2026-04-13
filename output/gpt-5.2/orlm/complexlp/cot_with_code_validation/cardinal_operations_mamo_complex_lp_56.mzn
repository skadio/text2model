% Resource redistribution / transportation problem (embedded data)

int: N = 5;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [221, 98, 337, 425, 250];
array[CITIES] of int: demand = [128, 317, 394, 108, 101];

array[CITIES, CITIES] of int: cost =
  [| 0, 20, 39,  4, 45
   | 1,  0,  8, 23, 44
   | 5, 46,  0, 36, 15
   | 3,  5, 10,  0, 27
   | 37,15,  7, 45,  0 |];

% Total supply is sufficient?
constraint sum(i in CITIES)(supply[i]) >= sum(j in CITIES)(demand[j]);

% Shipments (exclude self-arcs to reduce variables and speed up)
set of (int,int): ARCS = { (i,j) | i in CITIES, j in CITIES where i != j };

array[ARCS] of var 0..max(supply): x;

% Supply limits
constraint forall(i in CITIES)(
  sum((ii,j) in ARCS where ii == i)( x[(ii,j)] ) <= supply[i]
);

% Demand satisfaction
constraint forall(j in CITIES)(
  sum((i,jj) in ARCS where jj == j)( x[(i,jj)] ) >= demand[j]
);

var int: total_cost = sum((i,j) in ARCS)( x[(i,j)] * cost[i,j] );

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n"
];