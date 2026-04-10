% Soybean Transportation: terminals -> ports (destinations)
% Min-cost flow / transportation problem

int: NumTerminals; % K
int: NumPorts;     % L

array[1..NumTerminals, 1..NumPorts] of int: Cost;   % cost per ton
array[1..NumPorts] of int: Demand;                  % demand at each port
array[1..NumTerminals] of int: Supply;              % supply at each terminal

% Basic feasibility checks
constraint sum(Supply) >= sum(Demand);

% Decision variables: shipped tons from terminal k to port l
array[1..NumTerminals, 1..NumPorts] of var 0..sum(Supply): Ship;

% Supply constraints: do not exceed each terminal's supply
constraint forall(k in 1..NumTerminals)(
  sum(l in 1..NumPorts)(Ship[k,l]) <= Supply[k]
);

% Demand constraints: meet each port's demand exactly
constraint forall(l in 1..NumPorts)(
  sum(k in 1..NumTerminals)(Ship[k,l]) = Demand[l]
);

% Objective: minimize total transportation cost
var int: TotalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l] * Ship[k,l]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Ship =\n",
  show(Ship), "\n"
];