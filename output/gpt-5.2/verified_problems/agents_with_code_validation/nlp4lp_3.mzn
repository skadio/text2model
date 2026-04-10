% Parameters
int: T;                                   % Number of planning years
set of int: YEARS = 1..T;                 % Year index set

array[YEARS] of int: Demand;              % Electricity demand in year t
array[YEARS] of int: OilCap;              % Existing (oil-fired) capacity available in year t (not retired)

int: CoalCost;                            % Capital cost per unit of coal capacity built
int: NukeCost;                            % Capital cost per unit of nuclear capacity built
int: MaxNuke;                             % Maximum allowed nuclear capacity (absolute cap, per year)

int: CoalLife;                            % Lifetime (years) of coal plants
int: NukeLife;                            % Lifetime (years) of nuclear plants

% Bounds to keep the model tight and avoid timeout
int: MaxDemand = max(Demand);
int: MaxBuild = max(0, max(Demand) - min(OilCap));   % conservative upper bound on annual build
int: MaxCoalCap = CoalLife * MaxBuild;
int: MaxNukeCap = NukeLife * MaxBuild;

% Variables
array[YEARS] of var 0..MaxBuild: BuildCoal;          % Coal capacity built in year t
array[YEARS] of var 0..MaxBuild: BuildNuke;          % Nuclear capacity built in year t

array[YEARS] of var 0..MaxCoalCap: CoalCap;          % Total available coal capacity in year t
array[YEARS] of var 0..MaxNukeCap: NukeCap;          % Total available nuclear capacity in year t

% Constraints

% --- Capacity accumulation over plant lifetimes ---
constraint
  forall(t in YEARS) (
    CoalCap[t] =
      sum(k in max(1, t - CoalLife + 1)..t)(BuildCoal[k])
  );

constraint
  forall(t in YEARS) (
    NukeCap[t] =
      sum(k in max(1, t - NukeLife + 1)..t)(BuildNuke[k])
  );

% --- Demand satisfaction (must meet or exceed forecast demand each year) ---
constraint
  forall(t in YEARS) (
    OilCap[t] + CoalCap[t] + NukeCap[t] >= Demand[t]
  );

% --- Nuclear capacity policy/safety limit (absolute cap per year) ---
constraint
  forall(t in YEARS) (
    NukeCap[t] <= MaxNuke
  );

% Objective
solve minimize
  sum(t in YEARS) (CoalCost * BuildCoal[t] + NukeCost * BuildNuke[t]);