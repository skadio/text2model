% Parameters
par int: K;                                           % number of industries / products

array[1..K] of float: ManpowerOne;                    % manpower coefficients for operation one
array[1..K] of float: ManpowerTwo;                    % manpower coefficients for operation two

array[1..K] of float: Stock;                          % stock available at the beginning of the year
array[1..K] of float: Capacity;                       % productive capacity available for the current year
array[1..K] of float: Demand;                         % exogenous consumption demand to be met this year

array[1..K, 1..K] of float: InputOne;                 % input-output matrix for operation one
array[1..K, 1..K] of float: InputTwo;                 % input-output matrix for operation two


% Decision variables (all non-negative)
array[1..K] of var float: Production;                 % current-year output
array[1..K] of var float: BuildOne;                   % capacity-building via operation one
array[1..K] of var float: BuildTwo;                   % capacity-building via operation two


% Non-negativity
constraint forall(i in 1..K)(Production[i] >= 0.0);
constraint forall(i in 1..K)(BuildOne[i]   >= 0.0);
constraint forall(i in 1..K)(BuildTwo[i]   >= 0.0);


% 1. Demand satisfaction (stocks may be used together with current production)
constraint
  forall(i in 1..K)(
    Production[i] + Stock[i] >= Demand[i]
  );

% 2. Respect current productive capacity
constraint
  forall(i in 1..K)(
    Production[i] <= Capacity[i]
  );

% 3. Availability of current output (plus any surplus stock) for capacity-building inputs
constraint
  forall(j in 1..K)(
    sum(i in 1..K)(InputOne[i,j] * BuildOne[i]) +
    sum(i in 1..K)(InputTwo[i,j] * BuildTwo[i])
    <= Production[j] + Stock[j] - Demand[j]        % surplus of product j this year
  );


% Objective: maximise total manpower employed this year
var float: TotalManpower =
  sum(i in 1..K)(
      ManpowerOne[i] * BuildOne[i] +
      ManpowerTwo[i] * BuildTwo[i]
  );

solve maximize TotalManpower;