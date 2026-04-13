% Parameters
int: cost_co2 = 4;
int: cost_ch4 = 3;

int: max_total_reduction = 1000;
int: min_priority_gap = 200;          % 2*CO2 - CH4 >= 200
int: balanced_total = 400;            % (CO2/2) + CH4 = 400

% Variables
var 0..max_total_reduction: co2;
var 0..max_total_reduction: ch4;

var 0..(cost_co2*max_total_reduction + cost_ch4*max_total_reduction): total_cost;

% Constraints
constraint co2 + ch4 <= max_total_reduction;

constraint 2*co2 - ch4 >= min_priority_gap;

% Enforce exact balance with integrality:
% co2/2 + ch4 = 400  <=>  co2 + 2*ch4 = 800
constraint co2 + 2*ch4 = 2*balanced_total;

constraint total_cost = cost_co2*co2 + cost_ch4*ch4;

% Objective
solve minimize total_cost;