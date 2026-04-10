% Parameters
int: profit_chair = 43;
int: profit_dresser = 52;

float: stain_available = 17.0;
int: wood_available = 11;

float: stain_per_chair = 1.4;
float: stain_per_dresser = 1.1;

int: wood_per_chair = 2;
int: wood_per_dresser = 3;

% Variables
var 0..wood_available: chairs;
var 0..wood_available: dressers;

% Constraints
constraint stain_per_chair * chairs + stain_per_dresser * dressers <= stain_available;
constraint wood_per_chair * chairs + wood_per_dresser * dressers <= wood_available;

% Objective
solve maximize profit_chair * chairs + profit_dresser * dressers;