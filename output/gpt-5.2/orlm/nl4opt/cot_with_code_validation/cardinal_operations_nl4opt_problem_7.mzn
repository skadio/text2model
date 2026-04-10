% Parameters
float: profit_chair = 43.0;
float: profit_dresser = 52.0;

float: stain_avail = 17.0;
int: wood_avail = 11;

float: stain_per_chair = 1.4;
float: stain_per_dresser = 1.1;

int: wood_per_chair = 2;
int: wood_per_dresser = 3;

int: max_chairs = wood_avail div wood_per_chair;
int: max_dressers = wood_avail div wood_per_dresser;

% Variables
var 0..max_chairs: chairs;
var 0..max_dressers: dressers;

% Constraints
constraint stain_per_chair * chairs + stain_per_dresser * dressers <= stain_avail;
constraint wood_per_chair * chairs + wood_per_dresser * dressers <= wood_avail;

% Objective
solve maximize profit_chair * chairs + profit_dresser * dressers;