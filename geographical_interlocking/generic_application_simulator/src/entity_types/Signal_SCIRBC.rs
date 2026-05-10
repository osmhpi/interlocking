// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Signal_SCIRBCStruct {
    pub entity: EntitiesSignalItem,
    pub ApproachLockingActive: Triggerable<bool>, // input
    pub ApproachStatusRequested: bool, // output
}

impl Signal_SCIRBCStruct {
    pub fn new(entity: EntitiesSignalItem) -> Self {
        Self {
            entity,
            ApproachLockingActive: Triggerable::NotTriggered(false),
            ApproachStatusRequested: false,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.ApproachLockingActive = Triggerable::NotTriggered(false);
        self.ApproachStatusRequested = false;
        if (Some(self.entity.routes_starting_here.iter().any(|name| ctx.RouteManualRelease.get(name).unwrap().ManualReleaseWithholdMovementAuthority == ActiveInactive::ACTIVE))).unwrap_or(false) {
            self.ApproachStatusRequested = true;
        }
        if (Some(self.entity.routes_starting_here.iter().all(|name| ctx.RouteManualRelease.get(name).unwrap().ManualReleaseWithholdMovementAuthority == ActiveInactive::INACTIVE))).unwrap_or(false) {
            self.ApproachStatusRequested = false;
        }
    }
}
