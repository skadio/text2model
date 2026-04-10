% Parameters
int: min_calcium = 100;
int: min_iron = 50;

int: cost_milk = 1;
int: cost_veg  = 2;

int: calcium_milk = 40;
int: iron_milk    = 25;

int: calcium_veg = 15;
int: iron_veg    = 30;

% Variables
var 0..ceil(min_calcium div calcium_milk) + ceil(min_iron div iron_milk): milk;
var 0..max(ceil(min_calcium div calcium_veg), ceil(min_iron div iron_veg)): veg;

var 0..(cost_milk*(ceil(min_calcium div calcium_milk) + ceil(min_iron div iron_milk)) 
       + cost_veg*max(ceil(min_calcium div calcium_veg), ceil(min_iron div iron_veg))): total_cost;

% Constraints
constraint calcium_milk * milk + calcium_veg * veg >= min_calcium;
constraint iron_milk * milk + iron_veg * veg >= min_iron;

constraint total_cost = cost_milk * milk + cost_veg * veg;

% Objective
solve minimize total_cost;