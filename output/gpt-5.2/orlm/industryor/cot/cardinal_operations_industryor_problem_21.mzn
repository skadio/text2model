% Parameters (with values embedded)
int: P = 3;
set of int: Products = 1..P;

int: Days = 22;

array[Products] of int: maxDemand = [5300, 4500, 5400];                 % in units of 100kg
array[Products] of int: sellPrice = [124, 109, 115];                    % $ per 100kg
array[Products] of float: prodCost = [73.30, 52.90, 65.40];             % $ per 100kg
array[Products] of int: quotaPerDay = [500, 450, 550];                  % max units/day if fully devoted
array[Products] of int: activationCost = [170000, 150000, 100000];      % $
array[Products] of int: minBatch = [20, 20, 16];                        % minimum units if activated

% Variables
array[Products] of var 0..60000: x;          % production quantity (units of 100kg)
array[Products] of var bool: y;              % 1 if product line activated, else 0

% Constraints
constraint
  forall(i in Products) (
    x[i] <= maxDemand[i]
  );

% Total production capacity over the month:
% If all days were devoted to product i, max production is Days * quotaPerDay[i].
constraint
  forall(i in Products) (
    x[i] <= Days * quotaPerDay[i]
  );

% Minimum batch if activated; zero otherwise
constraint
  forall(i in Products) (
    x[i] >= minBatch[i] * bool2int(y[i])
  );

% Optional tightening: cannot produce if not activated
constraint
  forall(i in Products) (
    x[i] <= maxDemand[i] * bool2int(y[i])
  );

% Objective
% Maximize profit = sum_i (price - unit cost)*x_i - activationCost_i*y_i
var float: totalProfit =
  sum(i in Products)(
    (int2float(sellPrice[i]) - prodCost[i]) * int2float(x[i])
    - int2float(activationCost[i]) * bool2int(y[i])
  );

solve maximize totalProfit;