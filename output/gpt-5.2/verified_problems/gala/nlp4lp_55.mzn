include "globals.mzn";

% -----------------------------
% Data (provided in .dzn)
% -----------------------------
int: P;                         % number of power plants
int: C;                         % number of cities
array[1..P] of int: Supply;     % capacity of each plant
array[1..C] of int: Demand;     % demand of each city
array[1..P, 1..C] of int: TransmissionCosts;  % cost per unit from plant p to city c

% -----------------------------
% Decision variables
% -----------------------------
array[1..P, 1..C] of var 0..max(Supply): Send;   % electricity sent from p to c

% -----------------------------
% Constraints
% -----------------------------
% Plant capacity limits
constraint forall(p in 1..P) (
  sum(c in 1..C)(Send[p,c]) <= Supply[p]
);

% City demand must be met (exactly)
constraint forall(c in 1..C) (
  sum(p in 1..P)(Send[p,c]) = Demand[c]
);

% -----------------------------
% Objective: minimize total transmission cost
% -----------------------------
var int: TotalCost = sum(p in 1..P, c in 1..C)(TransmissionCosts[p,c] * Send[p,c]);

solve minimize TotalCost;

% -----------------------------
% Output
% -----------------------------
output [
  "TotalCost = ", show(TotalCost), "\n",
  "Send =\n",
  concat([ concat([ show(Send[p,c]) ++ if c = C then "\n" else " " endif
                  | c in 1..C ])
          | p in 1..P ])
];