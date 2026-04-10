% Parameters
int: nWeeks = 4;                                % number of weeks
set of int: WEEKS = 1..nWeeks;                  % week index set

array[WEEKS] of int: demand   = [15, 25, 35, 25];  % demand per week (1000 boxes)
array[WEEKS] of int: capacity = [30, 40, 45, 20];  % production capacity per week (1000 boxes)
array[WEEKS] of float: prodCost = [5.0, 5.1, 5.4, 5.5]; % cost per 1000 boxes (1000 yuan)

float: holdCost = 0.2;                          % storage cost per week per 1000 boxes (1000 yuan)

% Useful derived bounds
int: maxCap   = max(capacity);                    % maximum weekly capacity (1000 boxes)
int: totalCap = sum(w in WEEKS)(capacity[w]);     % total capacity across weeks (1000 boxes)
int: totalDem = sum(w in WEEKS)(demand[w]);       % total demand across weeks (1000 boxes)

% Variables
array[WEEKS] of var 0..maxCap: production;      % production in each week (1000 boxes)
array[WEEKS] of var 0..totalCap: inventory;     % end-of-week inventory (1000 boxes)

% Upper bounds are conservative and in (1000 yuan)
var 0.0..(sum(w in WEEKS)(prodCost[w]) * int2float(maxCap)): totalProdCost; % total production cost
var 0.0..(holdCost * int2float(totalCap) * int2float(nWeeks)): totalHoldCost; % total storage cost
var 0.0..1.0e9: totalCost;                      % total cost (1000 yuan)

% Constraints

%--- Feasibility: production limited by weekly capacity -----------------------
constraint
  forall(w in WEEKS) (
    production[w] <= capacity[w]
  );

%--- Inventory flow balance (meet demand each week using production + inventory)
% Assume no initial inventory: inventory at end of week 1 equals production1 - demand1
constraint
  inventory[1] = production[1] - demand[1];

% Inventory transition for subsequent weeks
constraint
  forall(w in 2..nWeeks) (
    inventory[w] = inventory[w-1] + production[w] - demand[w]
  );

%--- End condition: no backlogging; end-of-horizon inventory must be zero -------
constraint
  inventory[nWeeks] = 0;

%--- Cost accounting -----------------------------------------------------------
% Total production cost
constraint
  totalProdCost = sum(w in WEEKS) ( prodCost[w] * int2float(production[w]) );

% Total holding cost: pay holding cost for end-of-week inventory each week
constraint
  totalHoldCost = holdCost * sum(w in WEEKS) ( int2float(inventory[w]) );

% Total cost
constraint
  totalCost = totalProdCost + totalHoldCost;

% Objective
solve minimize totalCost;