% Parameters
% Selling prices ($/package)
float: price_meaties = 2.80;
float: price_yummies = 2.00;

% Ingredient requirements (pounds/package)
float: cereal_per_meaties = 2.0;
float: meat_per_meaties   = 3.0;

float: cereal_per_yummies = 3.0;
float: meat_per_yummies   = 1.5;

% Ingredient purchase limits (pounds/month)
float: cereal_available = 400000.0;
float: meat_available   = 300000.0;

% Ingredient costs ($/pound)
float: cereal_cost_per_lb = 0.20;
float: meat_cost_per_lb   = 0.50;

% Variable blending/packing costs ($/package)
float: var_cost_meaties = 0.25;
float: var_cost_yummies = 0.20;

% Capacity limit (packages/month)
int: meaties_capacity = 90000;


% Variables
% Production quantities (packages/month)
var 0..meaties_capacity: meaties_packages;  % bounded by machine capacity
var 0..1000000: yummies_packages;           % nonnegative with an explicit upper bound

% Ingredient usage (pounds/month)
var 0.0..cereal_available: cereal_used; % total cereal purchased/used
var 0.0..meat_available:   meat_used;   % total meat purchased/used

% Revenue and cost components ($/month)
var 0.0..1.0e9: revenue;
var 0.0..1.0e9: ingredient_cost;
var 0.0..1.0e9: packing_cost;

% Profit objective ($/month)
var -1.0e9..1.0e9: profit;


% Constraints
% Link total ingredient usage to production quantities
constraint
  cereal_used =
    cereal_per_meaties * meaties_packages +
    cereal_per_yummies * yummies_packages;

constraint
  meat_used =
    meat_per_meaties * meaties_packages +
    meat_per_yummies * yummies_packages;

% Respect monthly ingredient availability limits (purchasing caps)
constraint cereal_used <= cereal_available;
constraint meat_used   <= meat_available;

% Compute total revenue from sales
constraint
  revenue =
    price_meaties * meaties_packages +
    price_yummies * yummies_packages;

% Compute total ingredient purchasing cost
constraint
  ingredient_cost =
    cereal_cost_per_lb * cereal_used +
    meat_cost_per_lb * meat_used;

% Compute total blending/packing variable costs
constraint
  packing_cost =
    var_cost_meaties * meaties_packages +
    var_cost_yummies * yummies_packages;

% Define profit as revenue minus all variable costs
constraint
  profit = revenue - ingredient_cost - packing_cost;


% Objective
solve maximize profit;