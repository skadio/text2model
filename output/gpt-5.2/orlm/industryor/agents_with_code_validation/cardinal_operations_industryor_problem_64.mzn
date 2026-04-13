% Parameters
% Time requirements (hours per unit)
int: hoursA_microwave = 2;   % Workshop A processing hours per microwave
int: hoursB_microwave = 1;   % Workshop B assembly hours per microwave
int: hoursA_heater    = 1;   % Workshop A processing hours per water heater
int: hoursB_heater    = 3;   % Workshop B assembly hours per water heater

% Inspection & sales costs (yuan per unit)
int: inspCost_microwave = 30;
int: inspCost_heater    = 50;
int: inspCost_budget    = 5500;  % Monthly max inspection & sales cost

% Workshop capacities and costs
int: availA = 250;          % Regular available hours in workshop A per month
int: availB = 150;          % Regular available hours in workshop B per month
int: maxOvertimeA = 20;     % Max overtime hours in workshop A per month
int: costPerHourA = 80;     % Cost per hour in workshop A
int: costPerHourB = 20;     % Cost per hour in workshop B

% Sales/plan minimum requirements (units per month)
int: minMicrowaves = 80;    % At least 80 microwaves sold/produced
int: minHeaters    = 50;    % At least 50 water heaters sold/produced


% Variables
var 0..1000: microwave_units;     % Number of microwaves to produce per month
var 0..1000: heater_units;        % Number of water heaters to produce per month

var 0..(availA + maxOvertimeA): usedHoursA;  % Total hours used in workshop A (incl. overtime)
var 0..availB: usedHoursB;                  % Total hours used in workshop B (must be fully utilized)

var 0..maxOvertimeA: overtimeA;             % Overtime hours used in workshop A

var 0..inspCost_budget: inspSalesCost;      % Total monthly inspection & sales cost
var 0..1000000: laborCost;                  % Total labor cost for workshops A and B
var 0..1000000: totalCost;                  % Total cost (labor + inspection/sales)


% Constraints
% --- Production time accounting (workshop hours as functions of units) ---
constraint
  usedHoursA =
    hoursA_microwave * microwave_units +
    hoursA_heater    * heater_units;

constraint
  usedHoursB =
    hoursB_microwave * microwave_units +
    hoursB_heater    * heater_units;

% --- Full utilization requirements ---
% Workshop B must be fully utilized (no overtime defined for B)
constraint
  usedHoursB = availB;

% Workshop A regular time must be fully utilized, remaining (if any) is overtime
constraint
  usedHoursA = availA + overtimeA;

% --- Overtime limit for workshop A (redundant with domain, but explicit) ---
constraint
  overtimeA <= maxOvertimeA;

% --- Minimum monthly sales/production requirements ---
constraint
  microwave_units >= minMicrowaves;

constraint
  heater_units >= minHeaters;

% --- Inspection & sales cost accounting and budget limit ---
constraint
  inspSalesCost =
    inspCost_microwave * microwave_units +
    inspCost_heater    * heater_units;

constraint
  inspSalesCost <= inspCost_budget;

% --- Labor cost accounting (based on total hours used in each workshop) ---
constraint
  laborCost = costPerHourA * usedHoursA + costPerHourB * usedHoursB;

% --- Total cost aggregation ---
constraint
  totalCost = laborCost + inspSalesCost;


% Objective
solve minimize totalCost;