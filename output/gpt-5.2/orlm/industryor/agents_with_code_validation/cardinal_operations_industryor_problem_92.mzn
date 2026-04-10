% Parameters
% Conversion rates (kg of product per barrel of milk)
int: kgA1_per_barrel = 3;
int: kgA2_per_barrel = 4;

% Processing times (hours per barrel on each equipment type)
int: hoursA_per_barrel = 12;  % Type A equipment time per barrel (for A1)
int: hoursB_per_barrel = 8;   % Type B equipment time per barrel (for A2)

% Profits (yuan per kg)
int: profit_per_kg_A1 = 24;
int: profit_per_kg_A2 = 16;

% Daily resource limits
int: milk_barrels_available = 50;
int: labor_hours_available = 480;

% Equipment capacity (kg/day)
int: max_kg_A1 = 100; % Type A equipment can process at most this much A1 per day
% Type B equipment has no explicit capacity limit


% Variables
% Decision variables: number of barrels allocated to each product
var 0..milk_barrels_available: barrels_for_A1;  % barrels processed into A1
var 0..milk_barrels_available: barrels_for_A2;  % barrels processed into A2

% Produced quantities (kg), derived from barrels
var 0..(kgA1_per_barrel * milk_barrels_available): kg_A1;
var 0..(kgA2_per_barrel * milk_barrels_available): kg_A2;

% Total profit (yuan)
var 0..(profit_per_kg_A1 * kgA1_per_barrel * milk_barrels_available
      + profit_per_kg_A2 * kgA2_per_barrel * milk_barrels_available): total_profit;


% Constraints
% Link production quantities (kg) to allocated milk barrels
constraint kg_A1 = kgA1_per_barrel * barrels_for_A1;
constraint kg_A2 = kgA2_per_barrel * barrels_for_A2;

% Milk availability: total barrels allocated cannot exceed daily supply
constraint barrels_for_A1 + barrels_for_A2 <= milk_barrels_available;

% Labor time availability (hours): processing time per barrel on each equipment type
constraint hoursA_per_barrel * barrels_for_A1
         + hoursB_per_barrel * barrels_for_A2
         <= labor_hours_available;

% Type A equipment capacity: limit on daily production of A1 (kg/day)
constraint kg_A1 <= max_kg_A1;

% Profit definition from produced quantities
constraint total_profit = profit_per_kg_A1 * kg_A1
                        + profit_per_kg_A2 * kg_A2;


% Objective
solve maximize total_profit;