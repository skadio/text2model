% Facility location / transportation model (embedded data)

% Parameters
int: M = 8; % distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];
array[Centers] of int: cap      = [1447,   1886,   1962,   1392,   1191,   1218,   1088,   1178];

array[Stores] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];

% Transportation cost per unit
array[Centers, Stores] of int: transCost =
[
  [2, 3, 4, 5, 2, 3, 4, 5, 3], % c1
  [1, 2, 3, 4, 2, 3, 5, 4, 3], % c2
  [1, 1, 2, 3, 2, 2, 4, 3, 2], % c3
  [2, 3, 1, 5, 2, 4, 3, 2, 4], % c4
  [3, 2, 2, 4, 1, 3, 5, 2, 3], % c5
  [2, 4, 3, 2, 2, 1, 4, 5, 2], % c6
  [4, 3, 2, 3, 4, 2, 5, 3, 2], % c7
  [2, 2, 3, 4, 3, 2, 4, 1, 5]  % c8
];

int: maxCap  = max([cap[c] | c in Centers]);
int: maxShip = maxCap; % per center-store arc upper bound

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxShip: ship;

var int: totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

% Constraints: meet each store demand exactly
constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

% Capacity only if center is open
constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= cap[c] * bool2int(open[c])
  );

% Objective
solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in Centers]), "\n"
];