% Factory production planning (linear programming) in MiniZinc
% Maximize profit subject to equipment-hour capacity constraints.

% Data (embedded from the statement)
set of int: P = 1..3;          % products: 1=I, 2=II, 3=III
set of int: E = 1..3;          % equipment: 1=A, 2=B, 3=C

array[E, P] of int: req = 
  [|  8,  2, 10   % A hours per unit of product I, II, III
   | 10,  5,  8   % B
   |  2, 13, 10   % C
  |];

array[E] of int: cap = [300, 400, 420];         % monthly effective hours for A,B,C
array[P] of float: profit = [3.0, 2.0, 2.9];    % profit per unit (thousand yuan)

% Decision variables: production quantities (continuous, nonnegative)
array[P] of var float: x;
constraint forall(p in P)(x[p] >= 0.0);

% Capacity constraints
constraint forall(e in E)(
  sum(p in P)( req[e,p] * x[p] ) <= cap[e]
);

% Objective: maximize total profit
var float: z = sum(p in P)( profit[p] * x[p] );
solve maximize z;

output [
  "Optimal production quantities (units):\n",
  "  Product I   x1 = ", show(x[1]), "\n",
  "  Product II  x2 = ", show(x[2]), "\n",
  "  Product III x3 = ", show(x[3]), "\n",
  "Maximum profit (thousand yuan): ", show(z), "\n",
  "Equipment usage (hours):\n",
  "  A: ", show(sum(p in P)(req[1,p]*x[p])), " / ", show(cap[1]), "\n",
  "  B: ", show(sum(p in P)(req[2,p]*x[p])), " / ", show(cap[2]), "\n",
  "  C: ", show(sum(p in P)(req[3,p]*x[p])), " / ", show(cap[3]), "\n"
];