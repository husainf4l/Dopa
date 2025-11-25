using Dopa.Api.Dtos;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Dopa.Api.Services;

public interface IAppointmentService
{
    Task<IEnumerable<AppointmentDto>> GetAsync(Guid userId);
    Task<AppointmentDto?> CreateAsync(Guid userId, CreateAppointmentRequest request);
    Task<AppointmentDto?> UpdateAsync(Guid userId, Guid appointmentId, UpdateAppointmentRequest request);
    Task<bool> DeleteAsync(Guid userId, Guid appointmentId);
}
