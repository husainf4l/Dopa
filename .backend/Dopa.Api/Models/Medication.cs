using System;
using System.Collections.Generic;

namespace Dopa.Api.Models;

public class Medication : BaseEntity
{
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Dosage { get; set; } = string.Empty;
    public string Instructions { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
    public DateTime? EndDate { get; set; }

    public User? User { get; set; }
    public ICollection<MedicationReminder> Reminders { get; set; } = new List<MedicationReminder>();
}
