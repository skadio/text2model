% Parameters
int: K; % number of worker categories (e.g., unskilled / semi-skilled / skilled)
int: I; % number of years (planning periods)

array[1..K, 1..I] of int: Requirement; % required manpower in each category and year

array[1..K] of int: Strength; % current manpower strength in each category (all have > 1 year service)

array[1..K] of float: LessOneWaste; % wastage rate for workers with < 1 year service (by category)
array[1..K] of float: MoreOneWaste; % wastage rate for workers with >= 1 year service (by category)

array[1..K] of int: Recruit; % maximum number that can be recruited externally per year (by category)

array[1..K] of int: CostRedundancy; % redundancy cost per worker (by category)

int: NumOverman; % maximum total overmanning allowed over whole company (per year)
array[1..K] of int: CostOverman; % cost per overmanned worker per year (by category)

int: NumShortwork; % maximum number of workers on short-time working allowed (per year, total)
array[1..K] of int: CostShort; % cost per short-time worker per year (by category)


% Variables
array[1..K, 1..I] of var 0..max(Recruit): recruited; % number recruited in category k during year i

array[1..K, 1..I] of var 0..(max(Strength) + I * max(Recruit)): workforce; % total available workforce at end of year i

array[1..K, 1..I] of var 0..(max(Strength) + I * max(Recruit)): redundancies; % number made redundant in category k during year i

array[1..K, 1..I] of var 0..(max(Strength) + I * max(Recruit)): shortTime; % number put on short-time working in category k during year i

array[1..K, 1..I] of var 0..NumOverman: overmanning; % number employed above requirement (category k, year i)

var float: totalCost; % objective value (total cost over all years/categories)


% Constraints

%--- Recruitment capacity (per category, per year)
constraint
  forall(k in 1..K, i in 1..I) (
    recruited[k,i] <= Recruit[k]
  );

%--- Workforce flow / balance with wastage and redundancies
% All current workers are ">= 1 year service". Recruits are "< 1 year service" in the year recruited.
% End-of-year workforce = survivors of previous workforce + survivors of recruits - redundancies.
constraint
  forall(k in 1..K) (
    workforce[k,1] =
      round( (1.0 - MoreOneWaste[k]) * int2float(Strength[k])
           + (1.0 - LessOneWaste[k]) * int2float(recruited[k,1]) )
      - redundancies[k,1]
  );

constraint
  forall(k in 1..K, i in 2..I) (
    workforce[k,i] =
      round( (1.0 - MoreOneWaste[k]) * int2float(workforce[k,i-1])
           + (1.0 - LessOneWaste[k]) * int2float(recruited[k,i]) )
      - redundancies[k,i]
  );

%--- Do not make redundant more than the available pre-redundancy survivors
constraint
  forall(k in 1..K) (
    redundancies[k,1] <=
      round( (1.0 - MoreOneWaste[k]) * int2float(Strength[k])
           + (1.0 - LessOneWaste[k]) * int2float(recruited[k,1]) )
  );

constraint
  forall(k in 1..K, i in 2..I) (
    redundancies[k,i] <=
      round( (1.0 - MoreOneWaste[k]) * int2float(workforce[k,i-1])
           + (1.0 - LessOneWaste[k]) * int2float(recruited[k,i]) )
  );

%--- Short-time working limits (per year, total across company)
constraint
  forall(i in 1..I) (
    sum(k in 1..K)(shortTime[k,i]) <= NumShortwork
  );

%--- Production / requirement satisfaction with overmanning and short-time (short-time counts as half)
% Effective workforce for meeting requirement:
%   full-time equivalent = workforce - shortTime + 0.5*shortTime = workforce - 0.5*shortTime
% Must be at least Requirement, with slack captured as overmanning.
constraint
  forall(k in 1..K, i in 1..I) (
    int2float(workforce[k,i]) - 0.5 * int2float(shortTime[k,i]) =
      int2float(Requirement[k,i]) + int2float(overmanning[k,i])
  );

%--- Overmanning limits (per year, total across company)
constraint
  forall(i in 1..I) (
    sum(k in 1..K)(overmanning[k,i]) <= NumOverman
  );

%--- Short-time working cannot exceed available workforce in that category/year
constraint
  forall(k in 1..K, i in 1..I) (
    shortTime[k,i] <= workforce[k,i]
  );


% Objective
constraint
  totalCost =
    sum(k in 1..K, i in 1..I)(
        int2float(CostRedundancy[k]) * int2float(redundancies[k,i])
      + int2float(CostOverman[k])    * int2float(overmanning[k,i])
      + int2float(CostShort[k])      * int2float(shortTime[k,i])
    );

solve minimize totalCost;