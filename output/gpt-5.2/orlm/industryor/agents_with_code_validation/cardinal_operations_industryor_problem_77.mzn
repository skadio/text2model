% Parameters
int: nFullTime = 5;                 % number of full-time clerks
int: nPartTime = 4;                 % number of part-time clerks

int: hoursFullTime = 160;           % regular monthly working hours (full-time)
int: hoursPartTime = 80;            % regular monthly working hours (part-time)

int: rateFullTime = 5;              % sales volume (pairs/hour) for full-time
int: ratePartTime = 2;              % sales volume (pairs/hour) for part-time

float: wageFullTime = 1.0;          % wage (yuan/hour) for full-time regular hours
float: wagePartTime = 0.6;          % wage (yuan/hour) for part-time regular hours

float: overtimePayFullTime = 1.5;   % overtime pay (yuan/hour) for full-time
float: overtimePayPartTime = 0.7;   % overtime pay (yuan/hour) for part-time

float: profitPerPair = 0.3;         % profit per pair of shoes sold (yuan/pair)

int: salesTarget = 5500;            % goal p1: monthly sales target (pairs)

% Variables
var 0..10000: overtimeHoursFullTime;  % total overtime hours for all full-time clerks
var 0..10000: overtimeHoursPartTime;  % total overtime hours for all part-time clerks

var 0..100000: totalPairsSold;        % total pairs sold in the month (pairs)

var 0.0..1.0e9: totalProfit;          % total profit (yuan)
var 0.0..1.0e9: totalWageCost;        % total wage cost incl. overtime (yuan)

% Goal-deviation variables (goal programming style)
var 0..100000: devSalesShort;         % underachievement of sales target (pairs)
var 0..100000: devSalesExcess;        % overachievement of sales target (pairs)

% Constraints

%--------------------------------------------------------------------
% (C1) Total sales calculation from regular hours + overtime hours
%--------------------------------------------------------------------
constraint
  totalPairsSold =
    nFullTime * hoursFullTime * rateFullTime
  + nPartTime * hoursPartTime * ratePartTime
  + overtimeHoursFullTime * rateFullTime
  + overtimeHoursPartTime * ratePartTime;

%--------------------------------------------------------------------
% (C2) Goal p1: sales target with deviation variables (goal programming)
%     totalPairsSold + devSalesShort - devSalesExcess = salesTarget
%--------------------------------------------------------------------
constraint
  totalPairsSold + devSalesShort - devSalesExcess = salesTarget;

%--------------------------------------------------------------------
% (C3) Accounting: profit from sales
%--------------------------------------------------------------------
constraint
  totalProfit = profitPerPair * int2float(totalPairsSold);

%--------------------------------------------------------------------
% (C4) Accounting: total wage cost (regular wages + overtime wages)
%     Regular hours are fixed by staffing and monthly hours parameters.
%--------------------------------------------------------------------
constraint
  totalWageCost =
      wageFullTime * int2float(nFullTime * hoursFullTime)
    + wagePartTime * int2float(nPartTime * hoursPartTime)
    + overtimePayFullTime * int2float(overtimeHoursFullTime)
    + overtimePayPartTime * int2float(overtimeHoursPartTime);

%--------------------------------------------------------------------
% (C5) Goal p2: full employment of all clerks
%     Modeled as mandatory use of all regular hours (already embedded
%     in the sales and wage calculations via fixed regular hours).
%--------------------------------------------------------------------
constraint true;

%--------------------------------------------------------------------
% (C6) Goal p3: minimize overtime hours (objective handled elsewhere)
%     Keep overtime nonnegative is already ensured by variable domains.
%--------------------------------------------------------------------
constraint true;

% Objective
solve minimize devSalesShort + overtimeHoursFullTime + overtimeHoursPartTime;