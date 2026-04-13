% Parameters
% Nutrient minimum requirements (units/day)
int: min_calcium = 100;
int: min_iron    = 50;

% Food item costs ($/serving)
int: cost_milk = 1;
int: cost_veg  = 2;

% Nutrient content per serving (units/serving)
int: calcium_milk = 40;
int: iron_milk    = 25;

int: calcium_veg = 15;
int: iron_veg    = 30;

% Upper bounds for servings (safe finite bounds for an integer model)
% With positive nutrient contents, optimal solutions will not need more than
% the larger of the two minimum requirements if serving-by-serving gives >=1 unit.
int: max_req = max(min_calcium, min_iron);
int: max_servings = ceil(int2float(max_req) / 1.0);

% Variables
% Number of servings consumed (non-negative integers)
var 0..max_servings: milk_servings;
var 0..max_servings: veg_servings;

% Total daily cost ($)
var 0..(cost_milk * max_servings + cost_veg * max_servings): total_cost;

% Constraints
% Link total_cost to decision variables (linear cost calculation)
constraint
  total_cost = cost_milk * milk_servings + cost_veg * veg_servings;

% Meet minimum daily calcium requirement
constraint
  calcium_milk * milk_servings + calcium_veg * veg_servings >= min_calcium;

% Meet minimum daily iron requirement
constraint
  iron_milk * milk_servings + iron_veg * veg_servings >= min_iron;

% Objective
solve minimize total_cost;