int: K;
set of int: INDUSTRIES = 1..K;

array[INDUSTRIES, INDUSTRIES] of float: InputOne;
array[INDUSTRIES] of float: ManpowerOne;

array[INDUSTRIES, INDUSTRIES] of float: InputTwo;
array[INDUSTRIES] of float: ManpowerTwo;

array[INDUSTRIES] of float: Stock;
array[INDUSTRIES] of float: Capacity;

float: ManpowerLimit;
array[INDUSTRIES] of float: Demand;

% Large but finite upper bound for decision variables
float: BigM = 1.0e9;

% Decision variables
array[INDUSTRIES] of var 0.0..BigM: Production;   % yearly production (in £1 units)
array[INDUSTRIES] of var 0.0..BigM: Investment;   % capacity-building investment (in £1 units)

% Capacity cannot be exceeded by current production
constraint
  forall(i in INDUSTRIES)(
    Production[i] <= Capacity[i]
  );

% Material balance: supply covers demand, intermediate inputs, and investment inputs
constraint
  forall(j in INDUSTRIES)(
    Stock[j] + Production[j] >=
      Demand[j] +
      sum(i in INDUSTRIES)(Production[i] * InputOne[i,j]) +
      sum(i in INDUSTRIES)(Investment[i] * InputTwo[i,j])
  );

% Manpower limit (company-wide)
constraint
  sum(i in INDUSTRIES)(
    Production[i] * ManpowerOne[i] +
    Investment[i] * ManpowerTwo[i]
  ) <= ManpowerLimit;

% Objective: maximise productive capacity at the end of the horizon
solve maximize sum(i in INDUSTRIES)(Capacity[i] + Investment[i]);