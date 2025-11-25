using System;
using System.Collections.Generic;

namespace Dopa.Api.Dtos;

public record MedicationDto(Guid Id, string Name, string Dosage, string Instructions, DateTime StartDate, DateTime? EndDate, IEnumerable<MedicationReminderDto> Reminders);
public record MedicationReminderDto(Guid Id, DateTime ReminderTime, bool IsSent);
public record CreateMedicationRequest(string Name, string Dosage, string Instructions, DateTime StartDate, DateTime? EndDate, IEnumerable<DateTime>? Reminders);
public record UpdateMedicationRequest(string Name, string Dosage, string Instructions, DateTime StartDate, DateTime? EndDate, IEnumerable<DateTime>? Reminders);
