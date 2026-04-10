% Parameters (with values embedded)
int: nProducts = 2;
int: MW = 1; % microwave ovens
int: WH = 2; % water heaters

array[1..nProducts] of int: aHours = [2, 1]; % workshop A hours per unit
array[1..nProducts] of int: bHours = [1, 3]; % workshop B hours per unit

array[1..nProducts] of int: inspCost = [30, 50]; % inspection & sales cost per unit (yuan)

int: A_avail = 250;        % available hours in workshop A
int: B_avail = 150;        % available hours in workshop B
int: A_overtime_max = 20;  % max overtime hours in A

int: inspBudget = 5500;

int: demandMW = 80; % estimated/required sales per month
int: demandWH = 50;

% Variables
array[1..nProducts] of var 0..10000: x;  % production quantities
var 0..A_overtime_max: overtimeA;         % overtime in workshop A

% Constraints
constraint
  % At least required sales
  x[MW] >= demandMW /\
  x[WH] >= demandWH;

constraint
  % Inspection and sales costs budget
  sum(p in 1..nProducts)(inspCost[p] * x[p]) <= inspBudget;

constraint
  % Workshop B hours fully utilized (no overtime mentioned for B)
  sum(p in 1..nProducts)(bHours[p] * x[p]) = B_avail;

constraint
  % Workshop A hours fully utilized including overtime (bounded by max overtime)
  sum(p in 1..nProducts)(aHours[p] * x[p]) = A_avail + overtimeA;

% Objective
solve satisfy;