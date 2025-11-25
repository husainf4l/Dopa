namespace Dopa.Api.Configurations;

public class ReminderOptions
{
    public int MedicationLeadMinutes { get; set; } = 30;
    public int AppointmentLeadMinutes { get; set; } = 60;
    public int VaccineLeadHours { get; set; } = 24;
    public int PollingIntervalSeconds { get; set; } = 60;
}
