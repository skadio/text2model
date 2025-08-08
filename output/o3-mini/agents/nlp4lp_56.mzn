include "globals.mzn";

% Data from the input .dzn file
int: NumPorts;
int: NumTerminals;
array[1..NumTerminals, 1..NumPorts] of int: Cost;
array[1..NumPorts] of int: Demand;
array[1..NumTerminals] of int: Supply;

% Define an upper bound for the transported quantity on each route.
% No route can carry more than the supply of its terminal.
int: maxSupply = max(Supply);

% Decision variables: x[k,l] is the quantity transported from terminal k to port l.
array[1..NumTerminals, 1..NumPorts] of var 0..maxSupply: x;

% Each terminal can ship at most its supply.
constraint 
    forall(k in 1..NumTerminals)(
        sum(l in 1..NumPorts)( x[k,l] ) <= Supply[k]
    );

% Each port must receive exactly the demanded quantity.
constraint 
    forall(l in 1..NumPorts)(
        sum(k in 1..NumTerminals)( x[k,l] ) = Demand[l]
    );

% Objective: Minimize the total transportation cost.
var int: totalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)( x[k,l] * Cost[k,l] );

solve minimize totalCost;

output [
  "Transportation plan (rows: Terminals, columns: Ports):\n",
  concat([ "Terminal " ++ show(k) ++ ": " ++ show([ x[k,l] | l in 1..NumPorts ]) ++ "\n"
           | k in 1..NumTerminals ]),
  "Total cost: ", show(totalCost)
];