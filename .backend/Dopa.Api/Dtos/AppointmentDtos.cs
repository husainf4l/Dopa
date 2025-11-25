using System;

namespace Dopa.Api.Dtos;

public record AppointmentDto(Guid Id, string DoctorName, string Location, DateTime AppointmentDate, string? Notes);
public record CreateAppointmentRequest(string DoctorName, string Location, DateTime AppointmentDate, string? Notes);
public record UpdateAppointmentRequest(string DoctorName, string Location, DateTime AppointmentDate, string? Notes);
