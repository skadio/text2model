% Parameters
int: ParticipantsPerCircular;
int: ParticipantsPerRectangular;
int: BoardsPerCircular;
int: BoardsPerRectangular;
int: GuestsPerCircular;
int: GuestsPerRectangular;
int: SpacePerCircular;
int: SpacePerRectangular;
int: TotalSpace;
int: MinParticipants;
int: MinBoards;

% Decision variables
var 0..TotalSpace: CircularTables;
var 0..TotalSpace: RectangularTables;

% Objective variable
var int: TotalGuests;

% Constraints
constraint SpacePerCircular >= 0 /\ SpacePerRectangular >= 0 /\ TotalSpace >= 0;
constraint ParticipantsPerCircular >= 0 /\ ParticipantsPerRectangular >= 0;
constraint BoardsPerCircular >= 0 /\ BoardsPerRectangular >= 0;
constraint GuestsPerCircular >= 0 /\ GuestsPerRectangular >= 0;

constraint
  SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables <= TotalSpace;

constraint
  ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables >= MinParticipants;

constraint
  BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables >= MinBoards;

constraint
  TotalGuests = GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;

% Objective
solve maximize TotalGuests;

output [
  "CircularTables = ", show(CircularTables), "\n",
  "RectangularTables = ", show(RectangularTables), "\n",
  "TotalGuests = ", show(TotalGuests), "\n"
];