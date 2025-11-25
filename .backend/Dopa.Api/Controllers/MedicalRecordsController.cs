using System.Security.Claims;
using Dopa.Api.Dtos;
using Dopa.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Dopa.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/records")]
public class MedicalRecordsController : ControllerBase
{
    private readonly IMedicalRecordService _medicalRecordService;

    public MedicalRecordsController(IMedicalRecordService medicalRecordService)
    {
        _medicalRecordService = medicalRecordService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<MedicalRecordDto>>> Get()
    {
        var records = await _medicalRecordService.GetAsync(GetUserId());
        return Ok(records);
    }

    [HttpPost]
    [RequestSizeLimit(15_000_000)]
    public async Task<ActionResult<MedicalRecordDto>> Upload([FromForm] CreateMedicalRecordRequest request, IFormFile file)
    {
        var record = await _medicalRecordService.UploadAsync(GetUserId(), request, file);
        return record is null ? BadRequest() : Ok(record);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _medicalRecordService.DeleteAsync(GetUserId(), id);
        return deleted ? NoContent() : NotFound();
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
