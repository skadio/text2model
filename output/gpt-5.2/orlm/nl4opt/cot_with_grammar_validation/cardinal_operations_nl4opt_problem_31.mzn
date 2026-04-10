% Parameters
int: wood_available = 300;
int: oxygen_available = 300;

int: wood_with_catalyst = 10;
int: oxygen_with_catalyst = 20;
int: co2_with_catalyst = 15;

int: wood_without_catalyst = 15;
int: oxygen_without_catalyst = 12;
int: co2_without_catalyst = 18;

% Variables
var 0..min(wood_available div wood_with_catalyst, oxygen_available div oxygen_with_catalyst): x_with_catalyst;
var 0..min(wood_available div wood_without_catalyst, oxygen_available div oxygen_without_catalyst): x_without_catalyst;

var 0..(co2_with_catalyst * (wood_available div wood_with_catalyst) + co2_without_catalyst * (wood_available div wood_without_catalyst)): total_co2;

% Constraints
constraint wood_with_catalyst * x_with_catalyst + wood_without_catalyst * x_without_catalyst <= wood_available;
constraint oxygen_with_catalyst * x_with_catalyst + oxygen_without_catalyst * x_without_catalyst <= oxygen_available;

constraint total_co2 = co2_with_catalyst * x_with_catalyst + co2_without_catalyst * x_without_catalyst;

% Objective
solve maximize total_co2;