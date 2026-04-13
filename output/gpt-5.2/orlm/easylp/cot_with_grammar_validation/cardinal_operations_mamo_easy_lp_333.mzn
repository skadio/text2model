% Parameters
float: cost_coal = 0.8;
float: cost_gas = 1.2;
float: cost_wind = 1.0;
float: cost_solar = 1.5;

int: min_coal_gas = 500;
int: min_wind_solar = 200;

int: max_coal = 700;
int: max_gas = 600;
int: max_wind = 300;
int: max_solar = 250;

% Variables
var 0..max_coal: coal;
var 0..max_gas: gas;
var 0..max_wind: wind;
var 0..max_solar: solar;

var float: total_cost;

% Constraints
constraint coal + gas >= min_coal_gas;
constraint wind + solar >= min_wind_solar;

constraint total_cost = cost_coal * coal + cost_gas * gas + cost_wind * wind + cost_solar * solar;

% Objective
solve minimize total_cost;