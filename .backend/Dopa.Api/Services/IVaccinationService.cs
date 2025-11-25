using Dopa.Api.Dtos;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Dopa.Api.Services;

public interface IVaccinationService
{
    Task<IEnumerable<VaccineDoseDto>> GetAsync(Guid userId);
    Task<VaccineDoseDto?> CreateAsync(Guid userId, CreateVaccineDoseRequest request);
    Task<VaccineDoseDto?> UpdateAsync(Guid userId, Guid vaccineDoseId, UpdateVaccineDoseRequest request);
    Task<bool> DeleteAsync(Guid userId, Guid vaccineDoseId);
}
