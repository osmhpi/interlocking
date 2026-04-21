MACHINE SCIP_Point
SEES Enums
VARIABLES
  DetectedEndPosition,
  CommandedEndPosition
INVARIANT
  DetectedEndPosition : EulynxEndPosition &
  CommandedEndPosition : EulynxCommandedEndPosition
INITIALIZATION
  DetectedEndPosition := EulynxEndPosition_NO_END_POSITION;
  CommandedEndPosition := EulynxCommandedEndPosition_NOT_COMMANDED
OPERATIONS
  ComputeOutputs(PointOperation_State) =
    BEGIN
      IF bool(PointOperation_State = EulynxCommandedEndPosition_LEFT) = TRUE THEN
        CommandedEndPosition := EulynxCommandedEndPosition_LEFT
      ELSIF bool(PointOperation_State = EulynxCommandedEndPosition_RIGHT) = TRUE THEN
        CommandedEndPosition := EulynxCommandedEndPosition_RIGHT
      ELSIF bool(PointOperation_State = EulynxCommandedEndPosition_NOT_COMMANDED) = TRUE THEN
        CommandedEndPosition := EulynxCommandedEndPosition_NOT_COMMANDED
      ELSE
        CommandedEndPosition := EulynxCommandedEndPosition_NOT_COMMANDED
      END
    END
END//MACHINE
