% Parameters
int: K; % Total number of worker categories
int: I; % Number of years / planning periods

array[1..K, 1..I] of int: Requirement; % Required manpower by category and year
array[1..K] of int: Strength;         % Current manpower by category (all have >= 1 year service)

array[1..K] of float: LessOneWaste;   % Wastage rate for workers with < 1 year service
array[1..K] of float: MoreOneWaste;   % Wastage rate for workers with >= 1 year service

array[1..K] of int: Recruit;          % Max recruits allowed per year (by category)

array[1..K] of int: CostRedundancy;   % (Given but not used: objective is minimize redundancy count)

int: NumOverman;                      % Max total overmanning allowed across the company (per year)
array[1..K] of int: CostOverman;      % (Given but not used: objective is minimize redundancy count)

int: NumShortwork;                    % Max short-time workers allowed per category (per year)
array[1..K] of int: CostShort;        % (Given but not used: objective is minimize redundancy count)


% Variables
array[1..K, 1..I] of var 0..max(Recruit): recruit; % Recruited in category k during year t
array[1..K, 1..I] of var 0..max(Strength): redundant; % Made redundant in category k during year t

% End-of-year stocks by category/year:
array[1..K, 1..I] of var 0..max([max(Strength), max(Requirement)]): staff; % >= 1 year service
array[1..K, 1..I] of var 0..max(Recruit): new_staff; % < 1 year service

array[1..K, 1..I] of var 0..NumOverman: overman;      % Overmanning (FTE) by category/year
array[1..K, 1..I] of var 0..NumShortwork: shortwork;  % Short-time workers by category/year

array[1..K, 1..I] of var 0..max([max(Strength), max(Requirement)]): effective_supply;
% Effective available manpower in full-time equivalents (shortwork counts as 0.5 FTE)

var int: total_redundancy; % Total redundancies over all categories/years


% Constraints

% --- Recruitment and short-time working capacity limits (per category/year) ---
constraint
  forall(k in 1..K, t in 1..I) (
    recruit[k,t] <= Recruit[k] /\
    shortwork[k,t] <= NumShortwork
  );

% --- Year 1 workforce evolution ---
% Initial Strength are all >= 1 year service; apply MoreOneWaste to them.
% Recruits in year 1 suffer LessOneWaste and remain <1 year at end of year 1.
constraint
  forall(k in 1..K) (
    let {
      var int: survive_old = round((1.0 - MoreOneWaste[k]) * int2float(Strength[k])),
      var int: survive_new = round((1.0 - LessOneWaste[k]) * int2float(recruit[k,1]))
    } in
      staff[k,1] = survive_old - redundant[k,1] /\
      new_staff[k,1] = survive_new
  );

% --- Workforce evolution for years 2..I ---
% Previous staff and previous new_staff are now >=1 year service and suffer MoreOneWaste.
% Current recruits suffer LessOneWaste and remain <1 year at year end.
constraint
  forall(k in 1..K, t in 2..I) (
    let {
      var int: survive_old =
        round((1.0 - MoreOneWaste[k]) * int2float(staff[k,t-1] + new_staff[k,t-1])),
      var int: survive_new =
        round((1.0 - LessOneWaste[k]) * int2float(recruit[k,t]))
    } in
      staff[k,t] = survive_old - redundant[k,t] /\
      new_staff[k,t] = survive_new
  );

% --- No redundancies beyond available surviving workforce (per year) ---
constraint
  forall(k in 1..K) (
    redundant[k,1] <= round((1.0 - MoreOneWaste[k]) * int2float(Strength[k]))
  );
constraint
  forall(k in 1..K, t in 2..I) (
    redundant[k,t] <=
      round((1.0 - MoreOneWaste[k]) * int2float(staff[k,t-1] + new_staff[k,t-1]))
  );

% --- Effective supply definition (shortwork counts as 0.5 FTE) ---
% Work in integers by doubling everything:
% effective_supply = staff + new_staff - 0.5*shortwork
constraint
  forall(k in 1..K, t in 1..I) (
    effective_supply[k,t] * 2 = 2 * (staff[k,t] + new_staff[k,t]) - shortwork[k,t]
  );

% --- Meet requirements ---
constraint
  forall(k in 1..K, t in 1..I) (
    effective_supply[k,t] >= Requirement[k,t]
  );

% --- Overmanning definition and cap across company (per year) ---
% overman is an upper bound on any excess effective supply above requirement.
constraint
  forall(k in 1..K, t in 1..I) (
    effective_supply[k,t] - Requirement[k,t] <= overman[k,t]
  );
constraint
  forall(t in 1..I) (
    sum(k in 1..K)(overman[k,t]) <= NumOverman
  );

% --- Total redundancy aggregation (objective) ---
constraint
  total_redundancy = sum(k in 1..K, t in 1..I)(redundant[k,t]);


% Objective
solve minimize total_redundancy;