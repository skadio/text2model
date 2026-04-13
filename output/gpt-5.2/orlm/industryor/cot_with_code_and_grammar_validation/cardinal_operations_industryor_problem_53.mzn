% Factory production planning: maximize profit with equipment-hour capacities

% Sets
int: n_products = 3;
int: n_equip = 3;

set of int: P = 1..n_products; % 1=I, 2=II, 3=III
set of int: E = 1..n_equip;    % 1=A, 2=B, 3=C

% Data (hours required per unit product on each equipment)
array[E, P] of int: hours_req =
  array2d(E, P,
    [ 8,  2, 10,   % A for I,II,III
     10,  5,  8,   % B
      2, 13, 10    % C
    ]);

array[E] of int: capacity = [300, 400, 420];

% Profit per unit (thousand yuan). Use scaled integers to avoid float linear limits.
array[P] of int: profit10 = [30, 20, 29]; % profit * 10

% Variables (nonnegative integer production quantities)
array[P] of var 0..1000: x;

% Objective (scaled by 10)
var int: total_profit10;

% Constraints: equipment capacities
constraint forall(e in E)(
  sum(p in P)(hours_req[e,p] * x[p]) <= capacity[e]
);

% Total profit (scaled)
constraint total_profit10 = sum(p in P)(profit10[p] * x[p]);

% Objective
solve maximize total_profit10;

output [
  "x(I)   = ", show(x[1]), "\n",
  "x(II)  = ", show(x[2]), "\n",
  "x(III) = ", show(x[3]), "\n",
  "profit (thousand yuan) = ", show(int2float(total_profit10) / 10.0), "\n"
];