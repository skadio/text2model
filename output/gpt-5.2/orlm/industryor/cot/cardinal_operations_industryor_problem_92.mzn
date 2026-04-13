% Parameters (with values embedded)
int: milk_supply = 50;                 % barrels/day
int: labor_hours_available = 480;      % hours/day

int: kgA1_per_barrel = 3;
int: hoursA_per_barrel = 12;

int: kgA2_per_barrel = 4;
int: hoursB_per_barrel = 8;

int: profit_per_kg_A1 = 24;            % yuan/kg
int: profit_per_kg_A2 = 16;            % yuan/kg

int: cap_A1_kg = 100;                  % kg/day (Type A capacity)
int: max_barrels = milk_supply;        % cannot use more barrels than supply

% Variables
var 0..max_barrels: x1;                % barrels processed into A1
var 0..max_barrels: x2;                % barrels processed into A2
var 0..(kgA1_per_barrel * max_barrels): A1_kg;
var 0..(kgA2_per_barrel * max_barrels): A2_kg;

% Constraints
constraint x1 + x2 <= milk_supply;

constraint hoursA_per_barrel * x1 + hoursB_per_barrel * x2 <= labor_hours_available;

constraint A1_kg = kgA1_per_barrel * x1;
constraint A2_kg = kgA2_per_barrel * x2;

constraint A1_kg <= cap_A1_kg;

% Objective
solve maximize profit_per_kg_A1 * A1_kg + profit_per_kg_A2 * A2_kg;