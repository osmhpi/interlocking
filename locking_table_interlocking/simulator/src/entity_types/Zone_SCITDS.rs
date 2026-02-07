// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Zone_SCITDSStruct {
    pub entity: EntitiesZoneItem,
    pub OccupancyStatus: Triggerable<OccupancyStatus>, // input
    pub ResetSection: bool, // output
}

impl Zone_SCITDSStruct {
    pub fn new(entity: EntitiesZoneItem) -> Self {
        Self {
            entity,
            OccupancyStatus: Triggerable::NotTriggered(OccupancyStatus::OCCUPIED),
            ResetSection: false,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.ResetSection = false;
        if (match (Some(ctx.Zone.get(&self.entity.name).unwrap().State), Some(OccupancyStatus::VACANT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.ResetSection = true;
        }
        if (match (Some(ctx.Zone.get(&self.entity.name).unwrap().State), Some(OccupancyStatus::VACANT)) {
    (Some(l), Some(r)) => Some(l != r),
    _ => None
  }).unwrap_or(false) {
            self.ResetSection = false;
        }
    }
}
