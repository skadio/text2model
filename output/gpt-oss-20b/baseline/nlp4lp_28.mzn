int: K;

array[1..K] of int: Stock;
array[1..K] of int: Capacity;
array[1..K] of int: ManpowerOne;
array[1..K] of int: ManpowerTwo;
array[1..K,1..K] of float: InputOne;
array[1..K,1..K] of float: InputTwo;
float: ManpowerLimit;

% Decision variables
array[1..K,1..K] of int: prod;          % production of industry k in year t
array[1..K,1..K] of float: stock;       % stock of industry k at start of year t
array[1..K,1..K] of float: capacity;    % capacity of industry k in year t

% Initial stock (year 0)
array[1..K] of float: stock0 = [float(Stock[i]) | i in 1..K];

% Capacity at year 1 and 2 is the initial capacity
constraint
  forall(k in 1..K) (
    capacity[k,1] = float(Capacity[k]) /\
    capacity[k,2] = float(Capacity[k])
  );

% Capacity for years >=3
constraint
  forall(k in 1..K, t in 3..K) (
    capacity[k,t] = float(Capacity[k]) +
                    sum(i in 1..K) (
                      (InputOne[k,i] + InputTwo[k,i]) * float(prod[i,t-2])
                    )
  );

% Stock balance
constraint
  forall(k in 1..K) (
    % Year 1
    stock[k,1] = stock0[k] + float(prod[k,1]) -
                 sum(j in 1..K) (
                   (InputOne[j,k] + InputTwo[j,k]) * float(prod[j,1])
                 )
  );

constraint
  forall(k in 1..K, t in 2..K) (
    stock[k,t] = stock[k,t-1] + float(prod[k,t]) -
                 sum(j in 1..K) (
                   (InputOne[j,k] + InputTwo[j,k]) * float(prod[j,t])
                 )
  );

% Stock must be non‑negative
constraint
  forall(k in 1..K, t in 1..K) (
    stock[k,t] >= 0
  );

% Production must not exceed capacity
constraint
  forall(k in 1..K, t in 1..K) (
    float(prod[k,t]) <= capacity[k,t]
  );

% Manpower constraint for each year
constraint
  forall(t in 1..K) (
    sum(k in 1..K) (
      (float(ManpowerOne[k]) + float(ManpowerTwo[k])) * float(prod[k,t])
    ) <= ManpowerLimit
  );

% Production must be non‑negative
constraint
  forall(k in 1..K, t in 1..K) (
    prod[k,t] >= 0
  );

% Objective: maximise total production in the last two years
solve maximize
  sum(k in 1..K) (prod[k,K] + prod[k,K-1]);

%%% End of model %%%%