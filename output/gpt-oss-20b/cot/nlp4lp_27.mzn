% Parameters
int: K;
array[1..K,1..K] of float: InputOne;
array[1..K,1..K] of float: InputTwo;
array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;
array[1..K] of float: Stock;
array[1..K] of float: Capacity;
float: ManpowerLimit;
array[1..K] of float: Demand;

int: Y = 5; % Planning horizon (years)

% Variables
array[1..K,1..Y] of var 0.0..1000000.0: prod;   % Production units
array[1..K,1..Y] of var 0.0..1000000.0: cap;    % Capacity
array[1..K,1..Y] of var 0.0..1000000.0: stock;  % Stock of goods

% Constraints
% Initial conditions
constraint
  forall(i in 1..K) (
    cap[i,1] = Capacity[i] /\
    stock[i,1] = Stock[i]
  );

% Production cannot exceed current capacity
constraint
  forall(i in 1..K, t in 1..Y) (
    prod[i,t] <= cap[i,t]
  );

% Production at year t uses inputs from year t-1
constraint
  forall(i in 1..K, t in 2..Y) (
    prod[i,t] <= sum(j in 1..K) (InputOne[i,j] + InputTwo[i,j]) * prod[j,t-1]
  );

% Stock update: stock[t] = stock[t-1] + production[t-1] - inputs used - consumption
constraint
  forall(i in 1..K, t in 2..Y) (
    let {
      var float: input_used = sum(j in 1..K) (InputOne[i,j] + InputTwo[i,j]) * prod[j,t-1];
      var float: consumption = if t == Y then Demand[i] else 0 endif;
    } in
      stock[i,t] = stock[i,t-1] + prod[i,t-1] - input_used - consumption /\ 
      stock[i,t] >= 0
  );

% Capacity growth: capacity increases two years after production
constraint
  forall(i in 1..K, t in 2..Y) (
    cap[i,t] = cap[i,t-1] + (if t-2 >= 1 then sum(j in 1..K) (InputOne[j,i] + InputTwo[j,i]) * prod[j,t-2] else 0 endif)
  );

% Manpower constraint for each year
constraint
  forall(t in 1..Y) (
    sum(i in 1..K) (ManpowerOne[i] + ManpowerTwo[i]) * prod[i,t] <= ManpowerLimit
  );

% Objective: maximize final capacity
solve maximize
  sum(i in 1..K) cap[i,Y];