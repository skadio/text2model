% Parameters (with values embedded)
int: profit_chair = 43;
int: profit_dresser = 52;

float: stain_available = 17.0;
int: oak_available = 11;

float: stain_per_chair = 1.4;
int: oak_per_chair = 2;

float: stain_per_dresser = 1.1;
int: oak_per_dresser = 3;

% Variables
var 0..oak_available: chairs;
var 0..oak_available: dressers;
var int: total_profit;

% Constraints
constraint stain_per_chair * chairs + stain_per_dresser * dressers <= stain_available;
constraint oak_per_chair * chairs + oak_per_dresser * dressers <= oak_available;

constraint total_profit = profit_chair * chairs + profit_dresser * dressers;

% Objective
solve maximize total_profit;