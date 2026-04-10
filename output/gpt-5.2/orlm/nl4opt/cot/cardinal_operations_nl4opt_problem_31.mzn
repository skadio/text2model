% Parameters (with values embedded)
int: wood_available = 300;
int: oxygen_available = 300;

int: wood_with_cat = 10;
int: oxygen_with_cat = 20;
int: co2_with_cat = 15;

int: wood_without_cat = 15;
int: oxygen_without_cat = 12;
int: co2_without_cat = 18;

% Variables
var 0..min(wood_available div wood_with_cat, oxygen_available div oxygen_with_cat): x_with_cat;
var 0..min(wood_available div wood_without_cat, oxygen_available div oxygen_without_cat): x_without_cat;

var 0..(co2_with_cat * (wood_available div wood_with_cat) + co2_without_cat * (wood_available div wood_without_cat)): total_co2;

% Constraints
constraint wood_with_cat * x_with_cat + wood_without_cat * x_without_cat <= wood_available;
constraint oxygen_with_cat * x_with_cat + oxygen_without_cat * x_without_cat <= oxygen_available;

constraint total_co2 = co2_with_cat * x_with_cat + co2_without_cat * x_without_cat;

% Objective
solve maximize total_co2;