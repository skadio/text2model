%--------------------------------------------------------------------
%  MiniZinc model for maximizing profit of an auto‑parts manufacturer
%--------------------------------------------------------------------

int: P;                    % number of parts
int: M;                    % number of machines

array[1..M,1..P] of int: TimeRequired;   % hours per batch of part p on machine m
array[1..M] of int: MachineCosts;         % cost per hour for machine m
array[1..M] of int: Availability;         % available hours of machine m in the month
array[1..P] of int: Prices;               % selling price of one batch of part p
array[1..P] of int: MinBatches;           % minimum batches required for part p

%--------------------------------------------------------------------
% Decision variables
%--------------------------------------------------------------------
array[1..P] of var 0..1000: B;   % number of batches of each part

%--------------------------------------------------------------------
% Constraints
%--------------------------------------------------------------------
constraint forall(p in 1..P) (
    B[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
    sum(p in 1..P) (TimeRequired[m,p] * B[p]) <= Availability[m]
);

%--------------------------------------------------------------------
% Objective: maximise profit
%--------------------------------------------------------------------
var int: TotalRevenue =
    sum(p in 1..P) (Prices[p] * B[p]);

var int: TotalCost =
    sum(m in 1..M) (
        MachineCosts[m] *
        sum(p in 1..P) (TimeRequired[m,p] * B[p])
    );

solve maximize TotalRevenue - TotalCost;

%--------------------------------------------------------------------
% Output
%--------------------------------------------------------------------
output [
    "Batches per part: ", show(B), "\n",
    "Total Revenue   : ", show(TotalRevenue), "\n",
    "Total Cost      : ", show(TotalCost), "\n",
    "Profit          : ", show(TotalRevenue - TotalCost), "\n"
];