int: nProd = 3;
set of int: P = 1..nProd;

int: nEq = 3;
set of int: E = 1..nEq;

% Equipment indices: 1=A, 2=B, 3=C
array[E, P] of int: hours = array2d(E, P, [
  8,  2, 10,   % A: I, II, III
 10,  5,  8,   % B: I, II, III
  2, 13, 10    % C: I, II, III
]);

array[E] of int: cap = [300, 400, 420]; % effective monthly equipment hours

% Profit per unit (thousand yuan) for products I, II, III
array[P] of float: profit = [3.0, 2.0, 2.9];

% Decision variables: production quantities (continuous)
array[P] of var float: x;
constraint forall(p in P)(x[p] >= 0.0);

% Capacity constraints
constraint forall(e in E)(
  sum(p in P)(hours[e,p] * x[p]) <= cap[e]
);

var float: total_profit = sum(p in P)(profit[p] * x[p]);
solve maximize total_profit;

output [
  "Production (units):\n",
  "I   = ", show(x[1]), "\n",
  "II  = ", show(x[2]), "\n",
  "III = ", show(x[3]), "\n",
  "Total profit (thousand yuan) = ", show(total_profit), "\n"
];