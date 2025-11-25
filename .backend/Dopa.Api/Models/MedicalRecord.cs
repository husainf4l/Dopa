using System;

namespace Dopa.Api.Models;

public class MedicalRecord : BaseEntity
{
    public Guid UserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string FilePath { get; set; } = string.Empty;
    public string ContentType { get; set; } = "application/octet-stream";

    public User? User { get; set; }
}
