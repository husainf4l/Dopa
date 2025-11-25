using Dopa.Api.Dtos;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Dopa.Api.Services;

public interface IMedicalRecordService
{
    Task<IEnumerable<MedicalRecordDto>> GetAsync(Guid userId);
    Task<MedicalRecordDto?> UploadAsync(Guid userId, CreateMedicalRecordRequest request, IFormFile file);
    Task<bool> DeleteAsync(Guid userId, Guid recordId);
}
