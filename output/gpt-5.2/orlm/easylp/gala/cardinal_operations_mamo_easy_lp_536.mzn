% Crop planning: minimize total cost subject to acreage constraints.
include "globals.mzn";

% Data (embedded as requested)
int: costW = 10;
int: costC = 20;
int: costS = 30;

int: maxWC = 1000;
int: maxCS = 1500;
int: minWS = 500;
int: minWminusC = 200;

% Practical bounds (not explicitly given, so we use safe bounds implied by constraints)
% All acres are whole numbers.
var 0..maxWC: Wheat;          % W + C <= 1000 implies W <= 1000
var 0..maxWC: Corn;           % W + C <= 1000 implies C <= 1000
var 0..maxCS: Soybean;        % C + S <= 1500 implies S <= 1500

% Constraints
constraint Wheat + Corn <= maxWC;
constraint Corn + Soybean <= maxCS;
constraint Wheat + Soybean >= minWS;
constraint Wheat >= Corn + minWminusC;

% Objective: minimize total cost
var int: TotalCost = costW * Wheat + costC * Corn + costS * Soybean;
solve minimize TotalCost;

output [
  "Wheat=", show(Wheat), " acres\n",
  "Corn=", show(Corn), " acres\n",
  "Soybean=", show(Soybean), " acres\n",
  "TotalCost=", show(TotalCost), "\n",
  "RoundedTotalCost=", show(TotalCost), "\n"
];