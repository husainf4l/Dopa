using System;

namespace Dopa.Api.Models;

public class Appointment : BaseEntity
{
    public Guid UserId { get; set; }
    public string DoctorName { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public DateTime AppointmentDate { get; set; }
    public string? Notes { get; set; }

    public User? User { get; set; }
}
