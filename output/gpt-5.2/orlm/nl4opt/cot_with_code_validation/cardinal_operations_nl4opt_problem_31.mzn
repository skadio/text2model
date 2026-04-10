% Parameters
int: wood_available = 300;
int: oxygen_available = 300;

int: wood_with = 10;
int: oxygen_with = 20;
int: co2_with = 15;

int: wood_without = 15;
int: oxygen_without = 12;
int: co2_without = 18;

% Variables
var 0..(wood_available div wood_with): x_with;        % number of catalyst processes
var 0..(wood_available div wood_without): x_without;  % number of non-catalyst processes

var 0..(co2_with * (wood_available div wood_with) + co2_without * (wood_available div wood_without)): total_co2;

% Constraints
constraint wood_with * x_with + wood_without * x_without <= wood_available;
constraint oxygen_with * x_with + oxygen_without * x_without <= oxygen_available;

constraint total_co2 = co2_with * x_with + co2_without * x_without;

% Objective
solve maximize total_co2;