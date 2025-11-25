using System;
using System.Collections.Generic;

namespace Dopa.Api.Models;

public class User : BaseEntity
{
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public DateTime? DateOfBirth { get; set; }
    public string Role { get; set; } = "patient";
    public string? DeviceToken { get; set; }

    public ICollection<Medication> Medications { get; set; } = new List<Medication>();
    public ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
    public ICollection<VaccineDose> VaccineDoses { get; set; } = new List<VaccineDose>();
    public ICollection<MedicalRecord> MedicalRecords { get; set; } = new List<MedicalRecord>();
}
