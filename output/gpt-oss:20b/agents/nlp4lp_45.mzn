% -------------------------------------------------------------
% MiniZinc model for the container transportation problem
% -------------------------------------------------------------
% Input data
int: D;                          % number of ports
int: P;                          % number of depots
array[1..P] of int: Numdepot;    % containers available at each depot
array[1..D] of int: Numport;     % minimum containers required at each port
float: Price;                    % cost per unit distance
array[1..D, 1..P] of float: Distance;   % distance from port d to depot p

% Derived constants
int: maxSupply  = max(Numdepot);                      % maximum supply of any depot
int: maxBarges  = (maxSupply + 1) div 2;              % ceil(maxSupply/2)

% Decision variables
array[1..D, 1..P] of var 0..maxSupply : x;          % containers sent from depot d to port p
array[1..D, 1..P] of var 0..maxBarges : y;          % number of barges used for the shipment

% --------------------- Constraints -------------------------
% 1. Supply constraint – a depot cannot ship more than it has
constraint forall(d in 1..D)(
    sum(p in 1..P)( x[d][p] ) <= Numdepot[d]
);

% 2. Demand constraint – each port must receive at least its requirement
constraint forall(p in 1..P)(
    sum(d in 1..D)( x[d][p] ) >= Numport[p]
);

% 3. Barge capacity linking (y = ceil(x/2))
constraint forall(d in 1..D)(p in 1..P)(
    2*y[d][p] >= x[d][p] /\          % at least enough barges for the containers
    2*y[d][p] <= x[d][p] + 1          % at most one extra container per barge
);

% --------------------- Objective ---------------------------
var float: totalCost =
    sum(d in 1..D)(
        sum(p in 1..P)( y[d][p] * Distance[d][p] * Price )
    );

solve minimize totalCost;

% --------------------- Output ------------------------------
output [
    "Total cost = ", show(totalCost), "\n",
    "x = ", show(x), "\n",
    "y = ", show(y), "\n"
];