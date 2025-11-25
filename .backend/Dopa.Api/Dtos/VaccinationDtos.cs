using System;

namespace Dopa.Api.Dtos;

public record VaccineDoseDto(Guid Id, string VaccineName, string DoseNumber, DateTime ScheduledDate, DateTime? CompletedDate);
public record CreateVaccineDoseRequest(string VaccineName, string DoseNumber, DateTime ScheduledDate, DateTime? CompletedDate);
public record UpdateVaccineDoseRequest(string VaccineName, string DoseNumber, DateTime ScheduledDate, DateTime? CompletedDate);
