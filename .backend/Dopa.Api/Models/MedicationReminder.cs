using System;

namespace Dopa.Api.Models;

public class MedicationReminder : BaseEntity
{
    public Guid MedicationId { get; set; }
    public DateTime ReminderTime { get; set; }
    public bool IsSent { get; set; }

    public Medication? Medication { get; set; }
}
