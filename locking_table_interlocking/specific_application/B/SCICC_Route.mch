MACHINE SCICC_Route
SEES Enums
VARIABLES
  MsgRequestRoute,
  MsgReleaseRoute
INVARIANT
  MsgRequestRoute : BOOL &
  MsgReleaseRoute : BOOL
INITIALIZATION
  MsgRequestRoute := FALSE;
  MsgReleaseRoute := FALSE
OPERATIONS
  ComputeOutputs = skip
END//MACHINE
