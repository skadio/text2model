int: M = 9; % potential distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[Stores] of int: demand = [
  871, 462, 538, 898, 992, 791, 818, 688, 778
];

% Capacities (units), within the stated range 840..1856
array[Centers] of int: capacity = [
  1856, 1600, 1200, 1500, 1400, 1700, 1100, 900, 840
];

% Transportation cost per unit (dollars), values 1..5
array[Centers, Stores] of int: transCost = array2d(Centers, Stores, [
  2,3,4,2,5,3,2,4,3,
  3,2,5,3,4,2,3,5,4,
  1,2,3,2,3,4,2,3,4,
  4,3,2,5,2,3,4,2,1,
  2,5,3,4,1,2,3,4,2,
  3,1,2,3,2,5,4,2,3,
  5,4,3,2,3,1,2,3,4,
  2,3,4,1,2,3,5,4,2,
  4,2,1,3,4,2,3,1,5
]);

array[Centers] of var bool: open;

% shipment units from center i to store j
array[Centers, Stores] of var 0..max(demand): ship;

constraint
  forall(j in Stores) (
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([i | i in Centers where fix(open[i]) = true]), "\n",
  "Shipments (center,store,units):\n"
] ++
[
  if fix(ship[i,j]) > 0 then
    "(" ++ show(i) ++ "," ++ show(j) ++ "," ++ show(ship[i,j]) ++ ")\n"
  else "" endif
  | i in Centers, j in Stores
];