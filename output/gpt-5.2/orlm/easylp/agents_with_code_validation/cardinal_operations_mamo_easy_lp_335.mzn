% Parameters
% Demand requirement (MW)
int: demand_mw = 1000;

% Cost per MW for each plant type (USD/MW)
int: cost_coal = 50;
int: cost_gas = 60;
int: cost_solar = 70;
int: cost_nuclear = 80;

% Operational limits (MW)
int: coal_min = 0;
int: coal_max = 600;
int: gas_min = 0;
int: gas_max = 400;
int: solar_min = 300;
int: nuclear_min = 100;

% Additional regulatory/target/stability constraints (MW)
int: coal_emissions_cap = 500;      % coal output <= 500 due to emissions
int: solar_over_nuclear_min = 200;  % solar >= nuclear + 200
int: gas_solar_diff_max = 150;      % |gas - solar| <= 150


% Variables
% Power outputs (MW), whole-number megawatts
var coal_min..coal_max: coal_mw;
var gas_min..gas_max: gas_mw;
% Upper bounds set safely for a linear integer model; demand_mw suffices due to >= demand constraint
var solar_min..demand_mw: solar_mw;
var nuclear_min..demand_mw: nuclear_mw;

% Total cost (USD), bounded for solver robustness
var 0..(demand_mw * max([cost_coal, cost_gas, cost_solar, cost_nuclear])): total_cost;


% Constraints

% --- Demand satisfaction: meet or exceed total required capacity ---
constraint
  coal_mw + gas_mw + solar_mw + nuclear_mw >= demand_mw;

% --- Regulatory constraint: coal emissions cap (tighter than operational max) ---
constraint
  coal_mw <= coal_emissions_cap;

% --- Renewable target: solar must exceed nuclear by at least the required margin ---
constraint
  solar_mw >= nuclear_mw + solar_over_nuclear_min;

% --- Grid stability: gas and solar outputs must be close enough ---
constraint
  abs(gas_mw - solar_mw) <= gas_solar_diff_max;

% --- Cost accounting: total cost equals sum of per-plant costs ---
constraint
  total_cost =
    cost_coal    * coal_mw +
    cost_gas     * gas_mw +
    cost_solar   * solar_mw +
    cost_nuclear * nuclear_mw;


% Objective
solve minimize total_cost;

% Optional output
output [
  "coal_mw=", show(coal_mw), "\n",
  "gas_mw=", show(gas_mw), "\n",
  "solar_mw=", show(solar_mw), "\n",
  "nuclear_mw=", show(nuclear_mw), "\n",
  "total_cost=", show(total_cost), "\n"
];