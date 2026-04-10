% Linear programming model: allocate workshop hours to produce 3 components,
% each product requires 1 unit of each component; maximize completed products.

set of int: W = 1..4; % workshops A..D
set of int: C = 1..3; % components 1..3

array[W] of float: capacity = [100.0, 150.0, 80.0, 200.0];

% production_rate[w,c] in units/hour
array[W, C] of float: rate =
  [| 10.0, 15.0,  5.0  % A
   | 15.0, 10.0,  5.0  % B
   | 20.0,  5.0, 10.0  % C
   | 10.0, 15.0, 20.0  % D
  |];

% Decision variables: hours allocated by workshop to component
array[W, C] of var float: h;     % h[w,c] >= 0
var float: P;                    % number of completed products

constraint forall(w in W, c in C) (h[w,c] >= 0.0);

% Workshop hour limits
constraint forall(w in W) (
  sum(c in C)(h[w,c]) <= capacity[w]
);

% Component availability must support P completed products:
% total units of each component produced >= P
constraint forall(c in C) (
  sum(w in W)(rate[w,c] * h[w,c]) >= P
);

solve maximize P;

output [
  "Max products P = ", show(P), "\n",
  "Hours allocation h[w,c] (w=A..D, c=1..3):\n",
  concat([ "Workshop ", show(w), ": ",
           concat([ if c=1 then "" else "  " endif ++ "c" ++ show(c) ++ "=" ++ show(h[w,c])
                   | c in C ]),
           "\n"
         | w in W ])
];