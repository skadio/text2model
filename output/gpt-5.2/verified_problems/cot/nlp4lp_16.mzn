% Parameters
int: N;
set of int: P = 1..N;

array[P] of float: AssemblyHour;
array[P] of float: TestingHour;
array[P] of float: MaterialCost;
int: MaxAssembly;
int: MaxTesting;
int: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
array[P] of float: Price;

float: MaterialDiscount;        % percentage (e.g., 10 means 10%)
float: DiscountThreshold;       % $ threshold for total material bill

% Variables
array[P] of var int: x;                 % units produced of each product
var 0..MaxOvertimeAssembly: overtimeA;  % overtime assembly hours used
var bool: discount_applies;

% Constraints
constraint forall(i in P) (x[i] >= 0);

% Assembly: regular + overtime covers required assembly hours
constraint
  sum(i in P)(AssemblyHour[i] * int2float(x[i])) <= int2float(MaxAssembly) + overtimeA;

% Testing: limited by available testing hours
constraint
  sum(i in P)(TestingHour[i] * int2float(x[i])) <= int2float(MaxTesting);

% Discount applicability based on (undiscounted) total material bill
constraint
  discount_applies <-> (sum(i in P)(MaterialCost[i] * int2float(x[i])) >= DiscountThreshold);

% Objective
solve maximize
  % revenue
  sum(i in P)(Price[i] * int2float(x[i]))
  % minus material cost (with possible discount)
  - ( sum(i in P)(MaterialCost[i] * int2float(x[i]))
      * (1.0 - (MaterialDiscount/100.0) * bool2float(discount_applies)) )
  % minus overtime assembly cost
  - OvertimeAssemblyCost * overtimeA;