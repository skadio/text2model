% Budget allocation minimization for four categories

int: cost_stock = 5;
int: cost_rent = 4;
int: cost_wages = 3;
int: cost_util = 2;

% Decision variables: allocations (whole numbers)
var int: Stock;
var int: Rent;
var int: Wages;
var int: Utilities;

% Minimum requirements
constraint Stock >= 1000;
constraint Rent >= 500;
constraint Wages >= 1200;
constraint Utilities >= 300;

% Operational/financial constraints (interpreting "difference ... at least" as absolute difference)
constraint abs(Stock - Rent) >= 1000;
constraint Wages + Utilities <= 5000;
constraint abs(Stock - Wages) >= 1500;
constraint Rent + Utilities = 2000;

% Objective: minimize total monthly expenditure
var int: TotalCost = cost_stock * Stock + cost_rent * Rent + cost_wages * Wages + cost_util * Utilities;

solve minimize TotalCost;

output [
  "Stock=", show(Stock), "\n",
  "Rent=", show(Rent), "\n",
  "Wages=", show(Wages), "\n",
  "Utilities=", show(Utilities), "\n",
  "TotalCost=", show(TotalCost), "\n"
];