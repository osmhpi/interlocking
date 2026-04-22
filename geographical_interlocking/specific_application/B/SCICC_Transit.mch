MACHINE SCICC_Transit
SEES Enums
VARIABLES
  Active
INVARIANT
  Active : BOOL
INITIALIZATION
  Active := TRUE
OPERATIONS
  
  ComputeOutputs(Transit_State) = BEGIN
IF bool(Transit_State = ActiveInactive_ACTIVE) = TRUE THEN
        Active := TRUE
      ELSIF bool(Transit_State /= ActiveInactive_ACTIVE) = TRUE THEN
        Active := FALSE
      ELSE
        Active := TRUE
      END
    END
END//MACHINE
