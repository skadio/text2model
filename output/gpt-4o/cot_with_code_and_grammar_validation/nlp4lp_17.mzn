% Parameters
int: O;  % Number of crude-oil types
int: P;  % Number of product types
int: L;  % Number of production processes

array[1..O] of int: Allocated;               % Available barrels per crude-oil type
array[1..P] of int: Price;                   % Selling price of each product
array[1..L, 1..O] of int: Input;             % Crude-oil consumption per process execution
array[1..L, 1..P] of int: Output;            % Product output per process execution
array[1..L] of int: Cost;                    % Cost of executing each process once

% Upper bounds on the number of executions of each process
array[1..L] of float: UB =
  [ if exists(o in 1..O)(Input[l,o] > 0) then
        min([ int2float(Allocated[o]) / int2float(Input[l,o])
              | o in 1..O where Input[l,o] > 0 ])
    else
        0.0
    endif
  | l in 1..L ];

% Decision variables: number of times each process is executed
array[1..L] of var float: x;

% Non-negativity constraints
constraint
  forall(l in 1..L)( x[l] >= 0.0 );

% Resource constraints
constraint
  forall(o in 1..O)(
    sum(l in 1..L)( x[l] * int2float(Input[l,o]) ) <= int2float(Allocated[o])
  );

% Execution limits
constraint
  forall(l in 1..L)( x[l] <= UB[l] );

% Objective: maximise total profit
solve maximize
  sum(l in 1..L)(
    x[l] * ( sum(p in 1..P)( int2float(Output[l,p]) * int2float(Price[p]) )
             - int2float(Cost[l]) )
  );