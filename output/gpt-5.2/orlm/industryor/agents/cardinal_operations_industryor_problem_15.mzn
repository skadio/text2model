% Parameters
int: nMonths = 3;                          % Number of months in the planning horizon
set of int: MONTHS = 1..nMonths;           % Month index set

int: capacity = 500;                       % Warehouse capacity (max inventory)
int: initialStock = 200;                   % Inventory at end of previous year (start of month 1)

array[MONTHS] of int: buyPrice  = [8, 6, 9];    % Purchasing price per unit in each month
array[MONTHS] of int: sellPrice = [9, 8, 10];   % Selling price per unit in each month


% Variables
array[MONTHS] of var 0..capacity: buyQty;       % Units purchased at the beginning of each month
array[MONTHS] of var 0..capacity: sellQty;      % Units sold during each month
array[MONTHS] of var 0..capacity: stockEnd;     % Inventory at the end of each month


% Constraints

% Inventory balance constraints (flow conservation each month)
constraint
  forall(m in MONTHS) (
    stockEnd[m] =
      (if m = 1 then initialStock else stockEnd[m-1] endif) + buyQty[m] - sellQty[m]
  );

% Sales feasibility: cannot sell more than available inventory in the month
constraint
  forall(m in MONTHS) (
    sellQty[m] <= (if m = 1 then initialStock else stockEnd[m-1] endif) + buyQty[m]
  );

% Warehouse capacity constraints: end-of-month inventory cannot exceed capacity
constraint
  forall(m in MONTHS) (
    stockEnd[m] <= capacity
  );


% Objective
solve maximize sum(m in MONTHS) (sellPrice[m] * sellQty[m] - buyPrice[m] * buyQty[m]);