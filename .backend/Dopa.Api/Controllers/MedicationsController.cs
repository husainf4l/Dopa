using System.Security.Claims;
using Dopa.Api.Dtos;
using Dopa.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Dopa.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/medications")]
public class MedicationsController : ControllerBase
{
    private readonly IMedicationService _medicationService;

    public MedicationsController(IMedicationService medicationService)
    {
        _medicationService = medicationService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<MedicationDto>>> Get()
    {
        var items = await _medicationService.GetAsync(GetUserId());
        return Ok(items);
    }

    [HttpPost]
    public async Task<ActionResult<MedicationDto>> Create(CreateMedicationRequest request)
    {
        var result = await _medicationService.CreateAsync(GetUserId(), request);
        return CreatedAtAction(nameof(Get), new { id = result.Id }, result);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<MedicationDto>> Update(Guid id, UpdateMedicationRequest request)
    {
        var updated = await _medicationService.UpdateAsync(GetUserId(), id, request);
        return updated is null ? NotFound() : Ok(updated);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _medicationService.DeleteAsync(GetUserId(), id);
        return deleted ? NoContent() : NotFound();
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
