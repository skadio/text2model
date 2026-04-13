% Parameters
%--------------------------
% Cost coefficients (units per allocation unit)
%--------------------------
float: cost_raw_materials = 2.0;
float: cost_labour_hours = 3.0;
float: cost_production_costs = 1.5;
float: cost_transportation_costs = 4.0;

%--------------------------
% Constraint constants
%--------------------------
int: min_raw_plus_labour = 500;        % raw materials + labour hours >= 500
int: prod_over_half_raw_limit = 1000;  % production - 0.5*raw <= 1000
int: min_transport_minus_labour = 200; % transport - labour >= 200

%--------------------------
% Individual bounds (only non-negativity given)
%--------------------------
int: lb_raw = 0;
int: lb_labour = 0;
int: lb_production = 0;
int: lb_transport = 0;


% Variables
%--------------------------
% Integer decision variables (whole-number allocations)
%--------------------------
var int: raw_materials;
var int: labour_hours;
var int: production_costs;
var int: transportation_costs;


% Constraints
%--------------------------
% Domain / bounds constraints
%--------------------------
constraint raw_materials        >= lb_raw;
constraint labour_hours         >= lb_labour;
constraint production_costs     >= lb_production;
constraint transportation_costs >= lb_transport;

%--------------------------
% Productivity requirement
% raw materials + labour hours >= minimum threshold
%--------------------------
constraint raw_materials + labour_hours >= min_raw_plus_labour;

%--------------------------
% Production efficiency requirement (integer-safe linearization)
% production_costs - 0.5*raw_materials <= prod_over_half_raw_limit
% <=> 2*production_costs - raw_materials <= 2*prod_over_half_raw_limit
%--------------------------
constraint 2 * production_costs - raw_materials <= 2 * prod_over_half_raw_limit;

%--------------------------
% Logistics requirement
% transportation_costs - labour_hours >= minimum gap
%--------------------------
constraint transportation_costs - labour_hours >= min_transport_minus_labour;

%--------------------------
% Balance / policy constraint
% raw_materials + production_costs - labour_hours = 0
%--------------------------
constraint raw_materials + production_costs - labour_hours = 0;


% Objective
solve minimize (
    cost_raw_materials * raw_materials
  + cost_labour_hours * labour_hours
  + cost_production_costs * production_costs
  + cost_transportation_costs * transportation_costs
);

output [
  "raw_materials = ", show(raw_materials), "\n",
  "labour_hours = ", show(labour_hours), "\n",
  "production_costs = ", show(production_costs), "\n",
  "transportation_costs = ", show(transportation_costs), "\n",
  "total_cost = ", show(
      cost_raw_materials * raw_materials
    + cost_labour_hours * labour_hours
    + cost_production_costs * production_costs
    + cost_transportation_costs * transportation_costs
  ), "\n",
  "rounded_total_cost = ", show(round(
      cost_raw_materials * raw_materials
    + cost_labour_hours * labour_hours
    + cost_production_costs * production_costs
    + cost_transportation_costs * transportation_costs
  )), "\n"
];