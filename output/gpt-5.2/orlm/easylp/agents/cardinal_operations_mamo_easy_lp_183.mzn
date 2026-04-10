% Parameters
int: cost_coal = 4;        % cost per unit of coal electricity
int: cost_gas  = 3;        % cost per unit of gas electricity
int: cost_nuke = 2;        % cost per unit of nuclear electricity

int: demand_min = 5000;    % minimum total production required

int: max_coal = 3000;      % maximum coal production capacity
int: max_gas  = 2000;      % maximum gas production capacity
int: max_nuke = 1500;      % maximum nuclear production capacity


% Variables
var 0..max_coal: coal_units;   % integer units produced from coal
var 0..max_gas:  gas_units;    % integer units produced from gas
var 0..max_nuke: nuke_units;   % integer units produced from nuclear

var 0..(cost_coal*max_coal + cost_gas*max_gas + cost_nuke*max_nuke): total_cost;
% total production cost in dollars


% Constraints
% Demand satisfaction: total production must meet or exceed minimum demand
constraint
  coal_units + gas_units + nuke_units >= demand_min;

% Total cost definition: total_cost equals the weighted sum of production by source
constraint
  total_cost = cost_coal * coal_units
             + cost_gas  * gas_units
             + cost_nuke * nuke_units;


% Objective
solve minimize total_cost;