% Parameters
int: T;                                  % number of planning years
set of int: YEARS = 1..T;                % year index set

array[YEARS] of int: Demand;             % electricity demand in year t
array[YEARS] of int: OilCap;             % existing (oil) capacity available in year t

int: CoalCost;                           % capital cost per unit of coal capacity built
int: NukeCost;                           % capital cost per unit of nuclear capacity built

int: MaxNuke;                            % maximum allowed nuclear capacity (absolute cap per year)

int: CoalLife;                           % lifetime (years) of coal plants
int: NukeLife;                           % lifetime (years) of nuclear plants


% Variables
array[YEARS] of var int: BuildCoal;       % coal capacity newly established in year t (>= 0)
array[YEARS] of var int: BuildNuke;       % nuclear capacity newly established in year t (>= 0)

array[YEARS] of var int: CoalCap;         % total coal capacity available in year t (>= 0)
array[YEARS] of var int: NukeCap;         % total nuclear capacity available in year t (>= 0)

array[YEARS] of var int: TotalCap;        % total capacity in year t (>= 0): oil + coal + nuclear


% Constraints

% --- Capacity accumulation from builds over plant lifetimes ---
% Coal capacity in year t is the sum of all coal builds still alive in year t
constraint
  forall(t in YEARS) (
    CoalCap[t] =
      sum(y in YEARS where y <= t /\ t < y + CoalLife) (BuildCoal[y])
  );

% Nuclear capacity in year t is the sum of all nuclear builds still alive in year t
constraint
  forall(t in YEARS) (
    NukeCap[t] =
      sum(y in YEARS where y <= t /\ t < y + NukeLife) (BuildNuke[y])
  );

% --- Total capacity definition (oil + coal + nuclear) ---
constraint
  forall(t in YEARS) (
    TotalCap[t] = OilCap[t] + CoalCap[t] + NukeCap[t]
  );

% --- Demand satisfaction each year ---
constraint
  forall(t in YEARS) (
    TotalCap[t] >= Demand[t]
  );

% --- Nuclear policy/safety cap each year (absolute max) ---
constraint
  forall(t in YEARS) (
    NukeCap[t] <= MaxNuke
  );

% --- Nonnegativity of build and capacity decision variables ---
constraint
  forall(t in YEARS) (
    BuildCoal[t] >= 0 /\ BuildNuke[t] >= 0 /\
    CoalCap[t] >= 0   /\ NukeCap[t] >= 0 /\ TotalCap[t] >= 0
  );


% Objective
solve minimize
  sum(t in YEARS) (CoalCost * BuildCoal[t] + NukeCost * BuildNuke[t]);