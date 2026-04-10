% Crop planting cost minimization (all data embedded)

int: costCorn = 50;
int: costWheat = 30;
int: costSoy = 20;

% Decision variables: number of whole seed bags (each bag covers 1 acre)
var 0..100000: Corn;
var 0..100000: Wheat;
var 0..100000: Soybean;

% Constraints
constraint 2 * Corn + Wheat >= 1000;      % food security
constraint Wheat + Soybean <= 5000;       % soil health
constraint Corn - Soybean >= 1000;        % market demand

% Objective: minimize total cost
var int: TotalCost = costCorn * Corn + costWheat * Wheat + costSoy * Soybean;
solve minimize TotalCost;

output [
  "Corn=", show(Corn), "\n",
  "Wheat=", show(Wheat), "\n",
  "Soybean=", show(Soybean), "\n",
  "MinimumCost=", show(TotalCost), "\n"
];