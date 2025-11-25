using System;

namespace Dopa.Api.Dtos;

public record MedicalRecordDto(Guid Id, string Title, string? Description, string FilePath, string ContentType);
public record CreateMedicalRecordRequest(string Title, string? Description);
