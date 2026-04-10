% Parameters
int: nMonths = 6;                          % Number of months (Jul..Dec)
set of int: MONTHS = 1..nMonths;           % Month index set: 1=Jul, ..., 6=Dec

int: capacity = 500;                       % Max warehouse capacity (units)
int: initialStock = 200;                   % Stock at end of June (units)

array[MONTHS] of int: buyPrice  = [28,24,25,27,23,23];  % Buy price per unit for each month
array[MONTHS] of int: sellPrice = [29,24,26,28,22,25];  % Sell price per unit for each month

% Variables
array[MONTHS] of var 0..capacity: buyQty;    % Units purchased at beginning of each month
array[MONTHS] of var 0..capacity: sellQty;   % Units sold during each month
array[0..nMonths] of var 0..capacity: stock; % End-of-month stock (stock[0] is end of June)

% Constraints
% Initial stock (end of June)
constraint stock[0] = initialStock;

% Inventory balance: end-of-month stock evolution (purchases at beginning of month)
constraint
  forall(m in MONTHS) (
    stock[m] = stock[m-1] + buyQty[m] - sellQty[m]
  );

% Cannot sell more than available inventory within the month (after purchasing)
constraint
  forall(m in MONTHS) (
    sellQty[m] <= stock[m-1] + buyQty[m]
  );

% Warehouse capacity limit at end of each month (also enforced by variable domain)
constraint
  forall(m in 0..nMonths) (
    stock[m] <= capacity
  );

% Objective
solve maximize
  sum(m in MONTHS) (sellPrice[m] * sellQty[m] - buyPrice[m] * buyQty[m]);