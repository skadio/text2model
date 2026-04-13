% Parameters
% Cargo weight contribution per ship type
int: weightA = 2;
int: weightB = 3;
int: weightC = 4;

% Cargo volume contribution per ship type
int: volumeA = 3;
int: volumeB = 2;
int: volumeC = 1;

% Requirements / limits
int: minTotalWeight = 2000;
int: maxTotalVolume = 3000;
int: minDiffAoverB = 500; % ShipA must be at least 500 more than ShipB

% Operational costs per ship unit
int: costA = 7;
int: costB = 6;
int: costC = 5;

% Variables
% Number of ships of each type (non-negative integers), bounded from volume limits
var 0..1000: nA;   % 3*nA <= 3000 => nA <= 1000
var 0..1500: nB;   % 2*nB <= 3000 => nB <= 1500
var 0..3000: nC;   % 1*nC <= 3000 => nC <= 3000

% Total cost
var 0..(costA*1000 + costB*1500 + costC*3000): totalCost;

% Constraints
% Link total cost
constraint totalCost = costA*nA + costB*nB + costC*nC;

% --- Total cargo weight requirement (at least minTotalWeight) ---
constraint weightA * nA + weightB * nB + weightC * nC >= minTotalWeight;

% --- Total volume limit due to port restrictions (at most maxTotalVolume) ---
constraint volumeA * nA + volumeB * nB + volumeC * nC <= maxTotalVolume;

% --- Specific cargo requirement: ShipA must exceed ShipB by at least minDiffAoverB ---
constraint nA - nB >= minDiffAoverB;

% Objective
solve minimize totalCost;