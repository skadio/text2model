% Parameters
int: capA_refrig = 20;          % Refrigerated capacity of Type A truck (m^3)
int: capA_nonrefrig = 40;       % Non-refrigerated capacity of Type A truck (m^3)

int: capB_total = 60;           % Total capacity of Type B truck (m^3)
int: capB_refrig = capB_total div 2;      % Refrigerated capacity of Type B (equal split)
int: capB_nonrefrig = capB_total div 2;   % Non-refrigerated capacity of Type B (equal split)

int: demand_refrig = 3000;      % Required refrigerated volume (m^3)
int: demand_nonrefrig = 4000;   % Required non-refrigerated volume (m^3)

int: costA = 30;                % Cost per km for Type A truck (£/km)
int: costB = 40;                % Cost per km for Type B truck (£/km)

% Upper bounds for decision variables (safe bounds based on meeting demand with one type)
int: maxA = max( (demand_refrig + capA_refrig - 1) div capA_refrig,
                 (demand_nonrefrig + capA_nonrefrig - 1) div capA_nonrefrig );
int: maxB = max( (demand_refrig + capB_refrig - 1) div capB_refrig,
                 (demand_nonrefrig + capB_nonrefrig - 1) div capB_nonrefrig );

% Variables
var 0..maxA: numA;              % Number of Type A trucks to rent
var 0..maxB: numB;              % Number of Type B trucks to rent

var 0..(costA*maxA + costB*maxB): total_cost;  % Total cost (£/km)

% Constraints

% Meet or exceed refrigerated demand
constraint
  capA_refrig * numA + capB_refrig * numB >= demand_refrig;

% Meet or exceed non-refrigerated demand
constraint
  capA_nonrefrig * numA + capB_nonrefrig * numB >= demand_nonrefrig;

% Define total cost per km
constraint
  total_cost = costA * numA + costB * numB;

% Objective
solve minimize total_cost;