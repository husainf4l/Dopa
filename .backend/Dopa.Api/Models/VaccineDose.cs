using System;

namespace Dopa.Api.Models;

public class VaccineDose : BaseEntity
{
    public Guid UserId { get; set; }
    public string VaccineName { get; set; } = string.Empty;
    public string DoseNumber { get; set; } = string.Empty;
    public DateTime ScheduledDate { get; set; }
    public DateTime? CompletedDate { get; set; }

    public User? User { get; set; }
}
