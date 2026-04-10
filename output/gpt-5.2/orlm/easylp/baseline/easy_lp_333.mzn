% Energy generation cost minimization (all data embedded)

int: max_coal  = 700;
int: max_gas   = 600;
int: max_wind  = 300;
int: max_solar = 250;

int: min_coal_gas   = 500;
int: min_wind_solar = 200;

% Costs in cents to keep everything integral
int: cost_coal_c  = 80;   % $0.8
int: cost_gas_c   = 120;  % $1.2
int: cost_wind_c  = 100;  % $1.0
int: cost_solar_c = 150;  % $1.5

var 0..max_coal:  coal;
var 0..max_gas:   gas;
var 0..max_wind:  wind;
var 0..max_solar: solar;

constraint coal + gas >= min_coal_gas;
constraint wind + solar >= min_wind_solar;

var int: total_cost_cents =
  cost_coal_c  * coal +
  cost_gas_c   * gas +
  cost_wind_c  * wind +
  cost_solar_c * solar;

solve minimize total_cost_cents;

% Round to nearest whole dollar:
% nearest = floor((cents + 50) / 100)
var int: total_cost_dollars_rounded = (total_cost_cents + 50) div 100;

output [
  "coal=", show(coal), "\n",
  "gas=", show(gas), "\n",
  "wind=", show(wind), "\n",
  "solar=", show(solar), "\n",
  "total_cost_cents=", show(total_cost_cents), "\n",
  "total_cost_dollars_rounded=", show(total_cost_dollars_rounded), "\n"
];