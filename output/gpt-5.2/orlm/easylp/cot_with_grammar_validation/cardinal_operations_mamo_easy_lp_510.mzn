% Parameters
int: cost_steel = 10;
int: cost_wood = 15;
int: cost_plastic = 20;

int: req_2steel_plus_wood_min = 1000;
int: cap_steel_plus_plastic_max = 2000;
int: req_wood_minus_plastic_min = 500;
int: total_materials = 3500;

% Variables
var 0..total_materials: steel;
var 0..total_materials: wood;
var 0..total_materials: plastic;

var 0..(cost_steel*total_materials + cost_wood*total_materials + cost_plastic*total_materials): total_cost;

% Constraints
constraint 2 * steel + wood >= req_2steel_plus_wood_min;
constraint steel + plastic <= cap_steel_plus_plastic_max;
constraint wood - plastic >= req_wood_minus_plastic_min;
constraint steel + wood + plastic = total_materials;

constraint total_cost = cost_steel * steel + cost_wood * wood + cost_plastic * plastic;

% Objective
solve minimize total_cost;