// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Zone_SCICCStruct {
    pub entity: EntitiesZoneItem,
    pub CurrentOccupancy: OccupancyStatus, // output
}

impl Zone_SCICCStruct {
    pub fn new(entity: EntitiesZoneItem) -> Self {
        Self {
            entity,
            CurrentOccupancy: OccupancyStatus::VACANT,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.CurrentOccupancy = OccupancyStatus::VACANT;
        if (match (Some(ctx.Zone.get(&self.entity.name).unwrap().State), Some(OccupancyStatus::OCCUPIED)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CurrentOccupancy = OccupancyStatus::OCCUPIED;
        }
        if (match (Some(ctx.Zone.get(&self.entity.name).unwrap().State), Some(OccupancyStatus::VACANT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CurrentOccupancy = OccupancyStatus::VACANT;
        }
    }
}
