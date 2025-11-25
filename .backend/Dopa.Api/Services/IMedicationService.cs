using Dopa.Api.Dtos;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Dopa.Api.Services;

public interface IMedicationService
{
    Task<IEnumerable<MedicationDto>> GetAsync(Guid userId);
    Task<MedicationDto?> GetByIdAsync(Guid userId, Guid medicationId);
    Task<MedicationDto> CreateAsync(Guid userId, CreateMedicationRequest request);
    Task<MedicationDto?> UpdateAsync(Guid userId, Guid medicationId, UpdateMedicationRequest request);
    Task<bool> DeleteAsync(Guid userId, Guid medicationId);
}
