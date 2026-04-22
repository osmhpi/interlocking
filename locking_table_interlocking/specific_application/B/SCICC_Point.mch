MACHINE SCICC_Point
SEES Enums
VARIABLES
  CurrentPosition
INVARIANT
  CurrentPosition : E_EulynxEndPosition
INITIALIZATION
  CurrentPosition := EulynxEndPosition_NO_END_POSITION
OPERATIONS
  
  ComputeOutputs(SCIP_DetectedEndPosition) = BEGIN
IF bool(SCIP_DetectedEndPosition = EulynxEndPosition_LEFT) = TRUE THEN
        CurrentPosition := EulynxEndPosition_LEFT
      ELSIF bool(SCIP_DetectedEndPosition = EulynxEndPosition_RIGHT) = TRUE THEN
        CurrentPosition := EulynxEndPosition_RIGHT
      ELSIF bool(SCIP_DetectedEndPosition = EulynxEndPosition_NO_END_POSITION) = TRUE THEN
        CurrentPosition := EulynxEndPosition_NO_END_POSITION
      ELSE
        CurrentPosition := EulynxEndPosition_NO_END_POSITION
      END
    END
END//MACHINE
