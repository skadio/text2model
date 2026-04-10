include "globals.mzn";

% Cities: 1=E, 2=F, 3=G, 4=H, 5=I
int: n = 5;

% Cost matrix (0 on diagonal, symmetric as given)
array[1..n, 1..n] of int: cost =
[
  %   E   F   G   H   I
  |  0, 37, 72, 66, 33  % E
  | 37,  0, 26, 56,100  % F
  | 72, 26,  0, 49, 32  % G
  | 66, 56, 49,  0, 13  % H
  | 33,100, 32, 13,  0  % I
];

% Visit order of the 5 cities (a Hamiltonian cycle when we return to the start)
array[1..n] of var 1..n: city_order;
constraint all_different(city_order);

% Break rotational symmetry: fix starting city to E
constraint city_order[1] = 1;

% Total tour cost including return to start
var int: total_cost =
  sum(i in 1..n-1)( cost[city_order[i], city_order[i+1]] )
  + cost[city_order[n], city_order[1]];

solve minimize total_cost;

function string: cname(int: c) =
  if c = 1 then "E"
  elseif c = 2 then "F"
  elseif c = 3 then "G"
  elseif c = 4 then "H"
  else "I" endif;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Tour = ",
  concat([cname(fix(city_order[i])) ++ (if i < n then " -> " else "" endif) | i in 1..n]),
  " -> ", cname(fix(city_order[1])), "\n"
];