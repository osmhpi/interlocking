// Auto-generated evaluation context for state machines
use std::collections::HashMap;

use crate::graphs::*;
use crate::entity_types::*;

#[allow(non_camel_case_types)]
pub type PointLockLeft_map = HashMap<String, PointLockLeftStateMachine>;
#[allow(non_camel_case_types)]
pub type PointLockRight_map = HashMap<String, PointLockRightStateMachine>;
#[allow(non_camel_case_types)]
pub type PointMonitoring_map = HashMap<String, PointMonitoringStateMachine>;
#[allow(non_camel_case_types)]
pub type PointNominalPosition_map = HashMap<String, PointNominalPositionStateMachine>;
#[allow(non_camel_case_types)]
pub type PointOperation_map = HashMap<String, PointOperationStateMachine>;
#[allow(non_camel_case_types)]
pub type RouteAutomaticRelease_map = HashMap<String, RouteAutomaticReleaseStateMachine>;
#[allow(non_camel_case_types)]
pub type RouteManualRelease_map = HashMap<String, RouteManualReleaseStateMachine>;
#[allow(non_camel_case_types)]
pub type RouteMonitoring_map = HashMap<String, RouteMonitoringStateMachine>;
#[allow(non_camel_case_types)]
pub type Route_map = HashMap<String, RouteStateMachine>;
#[allow(non_camel_case_types)]
pub type SignalControl_map = HashMap<String, SignalControlStateMachine>;
#[allow(non_camel_case_types)]
pub type Signal_map = HashMap<String, SignalStateMachine>;
#[allow(non_camel_case_types)]
pub type Transit_map = HashMap<String, TransitStateMachine>;
#[allow(non_camel_case_types)]
pub type Zone_map = HashMap<String, ZoneStateMachine>;
#[allow(non_camel_case_types)]
pub type Point_SCIP_map = HashMap<String, Point_SCIPStruct>;
#[allow(non_camel_case_types)]
pub type Point_SCICC_map = HashMap<String, Point_SCICCStruct>;
#[allow(non_camel_case_types)]
pub type Route_SCICC_map = HashMap<String, Route_SCICCStruct>;
#[allow(non_camel_case_types)]
pub type Signal_SCICC_map = HashMap<String, Signal_SCICCStruct>;
#[allow(non_camel_case_types)]
pub type Signal_SCIRBC_map = HashMap<String, Signal_SCIRBCStruct>;
#[allow(non_camel_case_types)]
pub type Transit_SCICC_map = HashMap<String, Transit_SCICCStruct>;
#[allow(non_camel_case_types)]
pub type Zone_SCITDS_map = HashMap<String, Zone_SCITDSStruct>;
#[allow(non_camel_case_types)]
pub type Zone_SCICC_map = HashMap<String, Zone_SCICCStruct>;

#[allow(non_snake_case)]
#[allow(unused)]
pub struct EvalContext {
    pub PointLockLeft: PointLockLeft_map,
    pub PointLockRight: PointLockRight_map,
    pub PointMonitoring: PointMonitoring_map,
    pub PointNominalPosition: PointNominalPosition_map,
    pub PointOperation: PointOperation_map,
    pub RouteAutomaticRelease: RouteAutomaticRelease_map,
    pub RouteManualRelease: RouteManualRelease_map,
    pub RouteMonitoring: RouteMonitoring_map,
    pub Route: Route_map,
    pub SignalControl: SignalControl_map,
    pub Signal: Signal_map,
    pub Transit: Transit_map,
    pub Zone: Zone_map,
    pub Point_SCIP: Point_SCIP_map,
    pub Point_SCICC: Point_SCICC_map,
    pub Route_SCICC: Route_SCICC_map,
    pub Signal_SCICC: Signal_SCICC_map,
    pub Signal_SCIRBC: Signal_SCIRBC_map,
    pub Transit_SCICC: Transit_SCICC_map,
    pub Zone_SCITDS: Zone_SCITDS_map,
    pub Zone_SCICC: Zone_SCICC_map,
}