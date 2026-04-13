% Parameters (with values embedded)
int: costStock = 5;
int: costRent = 4;
int: costWages = 3;
int: costUtilities = 2;

int: minStock = 1000;
int: minRent = 500;
int: minWages = 1200;
int: minUtilities = 300;

int: diffStockRent = 1000;
int: diffStockWages = 1500;

int: maxWagesUtilities = 5000;

int: rentUtilitiesSum = 2000;

% Variables
var 0..200000: Stock;
var 0..200000: Rent;
var 0..200000: Wages;
var 0..200000: Utilities;

var 0..1000000000: totalCost;

% Constraints
constraint Stock >= minStock;
constraint Rent >= minRent;
constraint Wages >= minWages;
constraint Utilities >= minUtilities;

constraint Stock - Rent >= diffStockRent;
constraint Stock - Wages >= diffStockWages;

constraint Wages + Utilities <= maxWagesUtilities;

constraint Rent + Utilities = rentUtilitiesSum;

constraint totalCost = costStock * Stock
                     + costRent * Rent
                     + costWages * Wages
                     + costUtilities * Utilities;

% Objective
solve minimize totalCost;