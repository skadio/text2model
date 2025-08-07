%--------------------------------------------------------------------
%  Parameters (provided by the data file)
%--------------------------------------------------------------------
int: NumTerminals;                     % number of terminals
int: NumPorts;                        % number of ports

array[1..NumTerminals, 1..NumPorts] of int: Cost;   % transport cost
array[1..NumTerminals] of int: Supply;             % terminal supply
array[1..NumPorts] of int: Demand;                 % port demand

%--------------------------------------------------------------------
%  Decision variables
%--------------------------------------------------------------------
%  x[i,j] = amount shipped from terminal i to port j
array[1..NumTerminals, 1..NumPorts] of var 0..Supply[i] : x;

%--------------------------------------------------------------------
%  Constraints
%--------------------------------------------------------------------
%  Supply constraints – a terminal cannot ship more than it has
constraint
  forall(i in 1..NumTerminals) (
    sum(j in 1..NumPorts) x[i,j] <= Supply[i]
  );

%  Demand constraints – each port must receive at least its demand
constraint
  forall(j in 1..NumPorts) (
    sum(i in 1..NumTerminals) x[i,j] >= Demand[j]
  );

%--------------------------------------------------------------------
%  Objective
%--------------------------------------------------------------------
var int: total_cost = sum(i in 1..NumTerminals, j in 1..NumPorts)
                     Cost[i,j] * x[i,j];

solve minimize total_cost;

%--------------------------------------------------------------------
%  Output
%--------------------------------------------------------------------
output [
  "Total cost: ", show(total_cost), "\n",
  "Flows:\n",
  concat([ "  Terminal ", show(i), " -> Port ", show(j), ": ",
           show(x[i,j]), "\n" | i in 1..NumTerminals, j in 1..NumPorts ])
];