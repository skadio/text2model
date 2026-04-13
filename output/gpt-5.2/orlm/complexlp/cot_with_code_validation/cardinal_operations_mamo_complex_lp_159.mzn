% Facility location / distribution planning model (all data embedded)

%----------------------------
% Parameters
%----------------------------
int: M = 9; % distribution centers
int: N = 9; % retail stores

set of int: CENTERS = 1..M;
set of int: STORES  = 1..N;

array[CENTERS] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[STORES] of int: demand = [
  871, 462, 538, 898, 992, 791, 818, 688, 778
];

% Capacities (must be explicitly given in the model; chosen within stated range 840..1856)
array[CENTERS] of int: capacity = [
  1856, 1620, 1500, 1400, 1350, 1300, 1200, 1000, 900
];

% Transportation costs per unit (9x9 matrix, values 1..5)
array[CENTERS, STORES] of int: transCost = array2d(CENTERS, STORES, [
  1,2,3,4,5,1,2,3,4,
  2,1,2,3,4,2,1,2,3,
  3,2,1,2,3,3,2,1,2,
  4,3,2,1,2,4,3,2,1,
  5,4,3,2,1,5,4,3,2,
  1,2,3,4,5,1,2,3,4,
  2,3,4,5,1,2,3,4,5,
  3,4,5,1,2,3,4,5,1,
  4,5,1,2,3,4,5,1,2
]);

int: maxTotalDemand = sum(j in STORES)(demand[j]);

%----------------------------
% Decision variables
%----------------------------
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..maxTotalDemand: ship;

var 0..intmax: totalOpenCost;
var 0..intmax: totalShipCost;
var 0..intmax: totalCost;

%----------------------------
% Constraints
%----------------------------
constraint forall(j in STORES)(
  sum(i in CENTERS)(ship[i,j]) = demand[j]
);

constraint forall(i in CENTERS)(
  sum(j in STORES)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

constraint totalOpenCost = sum(i in CENTERS)(openCost[i] * bool2int(open[i]));
constraint totalShipCost = sum(i in CENTERS, j in STORES)(transCost[i,j] * ship[i,j]);
constraint totalCost = totalOpenCost + totalShipCost;

%----------------------------
% Objective
%----------------------------
solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "totalCost=", show(totalCost), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalShipCost=", show(totalShipCost), "\n",
  "open=", show(open), "\n"
];