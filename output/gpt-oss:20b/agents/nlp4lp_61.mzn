%----------------------------------------------------------------------
%  Container Loading / Yard Management Model
%----------------------------------------------------------------------
int: T;                               % number of periods
array[1..T] of int: Demands;          % demand each period
array[1..T] of int: UnloadCosts;      % cost per container unloaded
array[1..T] of int: UnloadCapacity;   % maximum unload per period
int: HoldingCost;                     % holding cost per container
int: MaxContainer;                    % maximum yard capacity
int: InitContainer;                   % initial containers in yard
int: NumCranes;                       % cranes available each period
int: CraneCapacity;                   % capacity of each crane
int: CraneCost;                       % cost per crane per period

% Derived constants
int: maxUnloadCap = max(UnloadCapacity);

%----------------------------------------------------------------------
%  Decision Variables
%----------------------------------------------------------------------
array[1..T] of var 0..maxUnloadCap:  u;          % containers unloaded
array[1..T] of var 0..NumCranes:      r;          % cranes rented
array[0..T] of var 0..MaxContainer:   y;          % containers in yard at end

%----------------------------------------------------------------------
%  Constraints
%----------------------------------------------------------------------
constraint y[0] = InitContainer;

constraint forall(t in 1..T)(
    % Inventory balance
    y[t] = y[t-1] + u[t] - Demands[t] /\

    % No shortage
    y[t] >= 0 /\

    % Yard capacity
    y[t] <= MaxContainer /\

    % Unload limits
    u[t] <= UnloadCapacity[t] /\

    % Crane capacity
    u[t] <= r[t] * CraneCapacity
);

% Yard empty after last period
constraint y[T] = 0;

%----------------------------------------------------------------------
%  Objective: minimize total cost
%----------------------------------------------------------------------
solve minimize
    sum(t in 1..T)( u[t] * UnloadCosts[t] +
                    r[t] * CraneCost    +
                    y[t] * HoldingCost );

%----------------------------------------------------------------------
%  Output
%----------------------------------------------------------------------
output [
    "Unloaded  : ", show(u), "\n",
    "Cranes   : ", show(r), "\n",
    "Inventory: ", show(y[1..T]), "\n",
    "Total cost: ", show(sum(t in 1..T)( u[t] * UnloadCosts[t] +
                                          r[t] * CraneCost +
                                          y[t] * HoldingCost )),
    "\n"
];