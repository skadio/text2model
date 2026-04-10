% Marketing budget distribution: TV vs Radio
% Minimize total cost subject to exposure/budget and prioritization constraints.

include "globals.mzn";

% Data (embedded from description)
int: min_total_units = 300;
int: max_total_units = 1000;
int: min_diff_tv_radio = 100;

int: cost_tv = 200;     % $ per unit
int: cost_radio = 500;  % $ per unit

% Decision variables: whole-number ad slots
var 0..max_total_units: tv_units;
var 0..max_total_units: radio_units;

% Total units and cost
var min_total_units..max_total_units: total_units = tv_units + radio_units;
var 0..(max_total_units * max(cost_tv, cost_radio)): total_cost =
    cost_tv * tv_units + cost_radio * radio_units;

% Constraints
constraint total_units >= min_total_units;
constraint total_units <= max_total_units;

% TV must be at least Radio by 100 units
constraint tv_units - radio_units >= min_diff_tv_radio;

solve minimize total_cost;

output [
  "TV units = ", show(tv_units), "\n",
  "Radio units = ", show(radio_units), "\n",
  "Total units = ", show(total_units), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];