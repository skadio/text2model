% Facility location / transportation problem
% Data embedded (no .dzn)

int: N = 9; % distribution centers
int: M = 8; % stores

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000,192000,114000,171000,160000,120000,182000,186000,174000];
array[ST] of int: demand   = [414, 920, 567, 789, 650, 480, 710, 835];
array[DC] of int: capacity = [1030, 1500, 1200, 1700, 1962, 1100, 1450, 1600, 1300];

array[DC,ST] of int: transCost =
[| 3, 4, 5, 6, 7, 5, 6, 4
 | 4, 5, 6, 7, 6, 4, 5, 6
 | 5, 4, 3, 6, 5, 6, 4, 7
 | 6, 7, 6, 4, 3, 5, 7, 5
 | 7, 6, 5, 3, 4, 6, 5, 6
 | 5, 4, 6, 5, 6, 3, 4, 5
 | 6, 5, 4, 7, 5, 4, 3, 6
 | 4, 6, 7, 5, 6, 5, 6, 3
 | 5, 6, 4, 6, 5, 7, 5, 4 |];

int: totalDemand = sum(s in ST)(demand[s]);

% Use integer 0/1 instead of bool to keep the model very MIP-friendly and fast.
array[DC] of var 0..1: open;

% Tight upper bound per (d,s): cannot exceed store demand, and cannot exceed DC capacity.
array[DC,ST] of var 0..totalDemand: ship;

% Demand satisfaction
constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

% Capacity only if open
constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * open[d]
);

% Stronger bounds to reduce search/solve time
constraint forall(d in DC, s in ST) (
  ship[d,s] <= demand[s]
);
constraint forall(d in DC, s in ST) (
  ship[d,s] <= capacity[d] * open[d]
);

var int: totalCost =
    sum(d in DC)(openCost[d] * open[d])
  + sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];