% Parameters
int: chop_capacity = 25;          % pounds of steel cut per chop saw per day
int: chop_waste = 25;             % waste units generated per chop saw per day
int: cutter_capacity = 5;         % pounds of steel cut per steel cutter per day
int: cutter_waste = 3;            % waste units generated per steel cutter per day

int: demand_lbs = 520;            % required pounds of steel to cut per day (minimum)
int: waste_limit = 400;           % maximum allowed waste units per day

% Variables
var 0..ceil(demand_lbs / chop_capacity): num_chop_saws;         % number of chop saws to purchase
var 0..ceil(demand_lbs / cutter_capacity): num_steel_cutters;   % number of steel cutters to purchase

% Constraints
% Meet or exceed daily steel cutting demand (capacity constraint)
constraint
  chop_capacity * num_chop_saws + cutter_capacity * num_steel_cutters >= demand_lbs;

% Stay within daily waste production limit (waste constraint)
constraint
  chop_waste * num_chop_saws + cutter_waste * num_steel_cutters <= waste_limit;

% Objective
solve minimize (num_chop_saws + num_steel_cutters);