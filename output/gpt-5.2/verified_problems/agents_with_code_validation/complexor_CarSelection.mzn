% Parameters
int: ParticipantNum;                            % total number of participants (from .dzn)
int: CarNum;                                    % total number of cars (from .dzn)

set of int: PARTICIPANTS = 1..ParticipantNum;   % participant index set
set of int: CARS = 1..CarNum;                   % car index set

array[PARTICIPANTS, CARS] of int: InterestMatrix; % 1 if participant p is interested in car c, else 0


% Variables
array[PARTICIPANTS, CARS] of var 0..1: assign;  % assign[p,c]=1 if participant p is assigned to car c
array[PARTICIPANTS] of var 0..1: assigned;      % assigned[p]=1 if participant p gets some car
var 0..ParticipantNum: total_assigned;          % total number of assigned participants


% Constraints

% Link "assigned[p]" to whether participant p is assigned to any car
constraint
  forall(p in PARTICIPANTS) (
    assigned[p] = sum(c in CARS)(assign[p,c])
  );

% Each participant can be assigned to at most one car
constraint
  forall(p in PARTICIPANTS) (
    sum(c in CARS)(assign[p,c]) <= 1
  );

% Participants can only be assigned to cars they are interested in
constraint
  forall(p in PARTICIPANTS, c in CARS) (
    assign[p,c] <= InterestMatrix[p,c]
  );

% Define total_assigned as the total number of assigned participants
constraint
  total_assigned = sum(p in PARTICIPANTS)(assigned[p]);


% Objective
solve maximize total_assigned;