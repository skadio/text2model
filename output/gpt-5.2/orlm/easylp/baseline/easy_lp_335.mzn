% Energy resource allocation - embedded data

int: demand = 1000;

% Costs ($/MW)
int: cost_coal = 50;
int: cost_gas = 60;
int: cost_solar = 70;
int: cost_nuclear = 80;

% Decision variables (MW), whole numbers
var 0..600: coal;
var 0..400: gas;
var 300..10000: solar;
var 100..10000: nuclear;

% Additional constraint: coal max limited to 500 MW due to regulations
constraint coal <= 500;

% Demand constraint
constraint coal + gas + solar + nuclear >= demand;

% Solar must exceed nuclear by at least 200 MW
constraint solar >= nuclear + 200;

% Gas and solar difference cannot exceed 150 MW
constraint abs(gas - solar) <= 150;

% Objective: minimize total cost
var int: total_cost = cost_coal*coal + cost_gas*gas + cost_solar*solar + cost_nuclear*nuclear;
solve minimize total_cost;

output [
  "coal_MW=", show(coal), "\n",
  "gas_MW=", show(gas), "\n",
  "solar_MW=", show(solar), "\n",
  "nuclear_MW=", show(nuclear), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];