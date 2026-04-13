% Parameters
int: max_coal = 700;
int: max_gas = 600;
int: max_wind = 300;
int: max_solar = 250;

int: min_coal_gas = 500;
int: min_wind_solar = 200;

int: scale = 10; % to avoid decimals
int: cost_coal = 8;   % 0.8 * 10
int: cost_gas = 12;   % 1.2 * 10
int: cost_wind = 10;  % 1.0 * 10
int: cost_solar = 15; % 1.5 * 10

% Variables
var 0..max_coal: coal;
var 0..max_gas: gas;
var 0..max_wind: wind;
var 0..max_solar: solar;

var 0..(cost_coal*max_coal + cost_gas*max_gas + cost_wind*max_wind + cost_solar*max_solar): total_cost_scaled;

% Constraints
constraint coal + gas >= min_coal_gas;
constraint wind + solar >= min_wind_solar;

constraint total_cost_scaled =
  cost_coal*coal + cost_gas*gas + cost_wind*wind + cost_solar*solar;

% Objective
solve minimize total_cost_scaled;