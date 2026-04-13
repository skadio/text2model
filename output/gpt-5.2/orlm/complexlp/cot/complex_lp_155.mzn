% Parameters (with values embedded)
int: N = 9; % potential distribution centers
int: M = 5; % retail stores

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Centers, Stores] of int: transCost =
[
  % S1 S2 S3 S4 S5
  | 3, 5, 4, 3, 5  % C1
  | 2, 4, 2, 4, 5  % C2
  | 1, 4, 2, 5, 4  % C3
  | 1, 1, 3, 3, 2  % C4
  | 4, 4, 3, 4, 4  % C5
  | 1, 3, 5, 3, 5  % C6
  | 1, 2, 4, 1, 4  % C7
  | 2, 2, 1, 2, 5  % C8
  | 2, 4, 4, 4, 4  % C9
];

array[Stores] of int: demand = [908, 434, 605, 480, 961];
array[Centers] of int: capacity = [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

int: totalDemand = sum(Stores)(demand[Stores]);
int: maxCapacity = max(capacity);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxCapacity: ship;

var int: total_open_cost;
var int: total_transport_cost;
var int: total_cost;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Optional strengthening bounds (redundant but helpful)
constraint
  forall(c in Centers, s in Stores)(
    ship[c,s] <= demand[s]
  );

% Objective
constraint total_open_cost = sum(c in Centers)(openCost[c] * bool2int(open[c]));
constraint total_transport_cost = sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);
constraint total_cost = total_open_cost + total_transport_cost;

solve minimize total_cost;

output [
  "Optimal total cost = ", show(total_cost), "\n",
  "  Opening cost     = ", show(total_open_cost), "\n",
  "  Transport cost   = ", show(total_transport_cost), "\n",
  "Open centers: ", show([c | c in Centers where fix(open[c]) == 1]), "\n"
];