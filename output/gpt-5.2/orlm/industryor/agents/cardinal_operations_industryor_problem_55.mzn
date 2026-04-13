% Parameters
int: nMonths = 3;                                  % Number of months in the quarter
set of int: MONTHS = 1..nMonths;                   % Month index set

int: warehouseCapacity = 5000;                     % Warehouse capacity (dan)
int: initialInventory = 1000;                      % Inventory on Jan 1 (dan)
int: targetEndInventory = 2000;                    % Required ending inventory after month 3 (dan)

int: initialCash = 20000;                          % Cash on Jan 1 (yuan)

array[MONTHS] of float: buyPrice  = [2.85, 3.05, 2.90];   % Purchase price (yuan/dan)
array[MONTHS] of float: sellPrice = [3.10, 3.25, 2.95];   % Selling price (yuan/dan)

% Variables
array[MONTHS] of var 0..warehouseCapacity: buyQty;        % Amount purchased in month m (dan)
array[MONTHS] of var 0..warehouseCapacity: sellQty;       % Amount sold in month m (dan)

array[0..nMonths] of var 0..warehouseCapacity: inventory; % End-of-month inventory (dan), inventory[0]=initial

% Cash is in yuan; it becomes fractional due to float prices, so use var float with a nonnegative domain.
array[0..nMonths] of var float: cash;                     % End-of-month cash (yuan), cash[0]=initial

var float: profit;                                        % Total profit over the quarter (yuan)

% Constraints

%---------------------------------------------
% Initial conditions (inventory and cash at start)
%---------------------------------------------
constraint inventory[0] = initialInventory;
constraint cash[0] = int2float(initialCash);

%---------------------------------------------
% Inventory flow constraints
% - Purchases arrive in the same month
% - Sales in month m are limited by inventory available from end of month m-1
%---------------------------------------------
constraint
  forall(m in MONTHS) (
    inventory[m] = inventory[m-1] + buyQty[m] - sellQty[m]
  );

% Cannot sell in month 1 (only grains already in stock can be sold next month)
constraint sellQty[1] = 0;

% Enforce "can only be sold in the next month": sales in month m come from purchases in month m-1
constraint
  forall(m in 2..nMonths) (
    sellQty[m] <= buyQty[m-1]
  );

% Additionally, sales cannot exceed inventory available at the start of the month
constraint
  forall(m in MONTHS) (
    sellQty[m] <= inventory[m-1]
  );

% Warehouse capacity respected each month (already in variable bounds, but stated for clarity)
constraint
  forall(m in 0..nMonths) (
    inventory[m] <= warehouseCapacity
  );

%---------------------------------------------
% Cash flow constraints
% - Payment required upon delivery (buying reduces cash in same month)
% - Selling increases cash in same month
% - No borrowing: cash cannot go negative
%---------------------------------------------
constraint
  forall(m in MONTHS) (
    cash[m] = cash[m-1]
              - buyPrice[m] * int2float(buyQty[m])
              + sellPrice[m] * int2float(sellQty[m])
  );

constraint forall(m in 0..nMonths) (cash[m] >= 0.0);

%---------------------------------------------
% End-of-quarter inventory requirement
%---------------------------------------------
constraint inventory[nMonths] = targetEndInventory;

%---------------------------------------------
% Profit definition over the quarter
%---------------------------------------------
constraint
  profit =
    sum(m in MONTHS) (
      sellPrice[m] * int2float(sellQty[m]) - buyPrice[m] * int2float(buyQty[m])
    );

% Objective
solve maximize profit;