% Parameters
int: milk_supply_barrels = 50;          % Daily milk supply (barrels)
int: labor_hours_available = 480;       % Daily available labor time (hours)

int: a1_kg_per_barrel = 3;              % Output of A1 per barrel of milk (kg)
int: a2_kg_per_barrel = 4;              % Output of A2 per barrel of milk (kg)

int: a1_hours_per_barrel = 12;          % Type A equipment time per barrel (hours) to make A1
int: a2_hours_per_barrel = 8;           % Type B equipment time per barrel (hours) to make A2

int: profit_per_kg_a1 = 24;             % Profit per kg of A1 (yuan)
int: profit_per_kg_a2 = 16;             % Profit per kg of A2 (yuan)

int: a1_capacity_kg = 100;              % Max daily production capacity for A1 (kg)
% Note: Type B equipment has no explicit capacity limit.

% Variables
var 0..milk_supply_barrels: barrels_to_a1;  % Barrels of milk allocated to product A1
var 0..milk_supply_barrels: barrels_to_a2;  % Barrels of milk allocated to product A2

var 0..(a1_kg_per_barrel * milk_supply_barrels): kg_a1; % Produced kg of A1
var 0..(a2_kg_per_barrel * milk_supply_barrels): kg_a2; % Produced kg of A2

var 0..labor_hours_available: labor_hours_used;          % Total labor hours used

var 0..(profit_per_kg_a1 * a1_kg_per_barrel * milk_supply_barrels
      + profit_per_kg_a2 * a2_kg_per_barrel * milk_supply_barrels): profit; % Total daily profit

% Constraints

% Milk allocation constraint: total barrels used cannot exceed daily milk supply
constraint
  barrels_to_a1 + barrels_to_a2 <= milk_supply_barrels;

% Production definition constraints: link barrels allocated to produced kilograms
constraint
  kg_a1 = a1_kg_per_barrel * barrels_to_a1;
constraint
  kg_a2 = a2_kg_per_barrel * barrels_to_a2;

% Labor usage definition and availability constraints
constraint
  labor_hours_used = a1_hours_per_barrel * barrels_to_a1
                   + a2_hours_per_barrel * barrels_to_a2;
constraint
  labor_hours_used <= labor_hours_available;

% Type A equipment capacity constraint (A1 production limit)
constraint
  kg_a1 <= a1_capacity_kg;

% Profit definition constraint
constraint
  profit = profit_per_kg_a1 * kg_a1 + profit_per_kg_a2 * kg_a2;

% Objective
solve maximize profit;